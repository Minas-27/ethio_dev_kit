import AVFoundation
import Flutter
import Speech
import UIKit

/// Amharic speech-to-text plugin backed by iOS `SFSpeechRecognizer`.
///
/// Method channel `com.abroid.amharic_stt/methods` handles control calls; event
/// channel `com.abroid.amharic_stt/results` streams transcription updates.
///
/// This wraps the platform recognizer fixed to the `am-ET` locale — it does not
/// implement recognition itself. Whether Amharic resolves at all depends on the
/// iOS version and the device's installed speech assets, which `isAvailable`
/// probes via `SFSpeechRecognizer(locale:)` and `supportedLocales()`.
public class AmharicSttPlugin: NSObject, FlutterPlugin {
  private static let localeIdentifier = "am-ET"

  private let recognizer = SFSpeechRecognizer(locale: Locale(identifier: localeIdentifier))
  private let audioEngine = AVAudioEngine()

  private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
  private var recognitionTask: SFSpeechRecognitionTask?
  private var eventSink: FlutterEventSink?
  private var isListening = false

  public static func register(with registrar: FlutterPluginRegistrar) {
    let methodChannel = FlutterMethodChannel(
      name: "com.abroid.amharic_stt/methods",
      binaryMessenger: registrar.messenger())
    let eventChannel = FlutterEventChannel(
      name: "com.abroid.amharic_stt/results",
      binaryMessenger: registrar.messenger())

    let instance = AmharicSttPlugin()
    registrar.addMethodCallDelegate(instance, channel: methodChannel)
    eventChannel.setStreamHandler(instance)
  }

  // MARK: - Method channel

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "isAvailable":
      result(isAmharicAvailable())
    case "startListening":
      let args = call.arguments as? [String: Any]
      let partial = (args?["partialResults"] as? Bool) ?? true
      startListening(partialResults: partial, result: result)
    case "stopListening":
      stopListening()
      result(nil)
    case "cancel":
      cancel()
      result(nil)
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  /// True only when a recognizer for `am-ET` exists, reports itself available,
  /// and Amharic is in the set of supported locales.
  private func isAmharicAvailable() -> Bool {
    guard let recognizer = recognizer, recognizer.isAvailable else { return false }
    let target = Locale(identifier: Self.localeIdentifier).identifier
    let supported = SFSpeechRecognizer.supportedLocales().map { $0.identifier }
    // Match either "am-ET" or the language-only "am", depending on how the OS
    // enumerates it.
    return supported.contains(target) || supported.contains { $0.hasPrefix("am") }
  }

  private func startListening(partialResults: Bool, result: @escaping FlutterResult) {
    if isListening {
      result(flutterError("recognizer_busy", "A recognition session is already active."))
      return
    }
    guard let recognizer = recognizer, recognizer.isAvailable else {
      result(flutterError("locale_unavailable",
        "Amharic (\(Self.localeIdentifier)) is not available on this device."))
      return
    }

    requestAuthorization { [weak self] authorized in
      guard let self = self else { return }
      guard authorized else {
        result(self.flutterError("permission_denied",
          "Speech recognition or microphone permission was denied."))
        return
      }
      do {
        try self.beginSession(partialResults: partialResults)
        result(nil)
      } catch {
        self.isListening = false
        result(self.flutterError(
          "audio", "Failed to start audio session: \(error.localizedDescription)"))
      }
    }
  }

  /// Requests both speech-recognition and microphone authorization, calling
  /// [completion] on the main thread with the combined result.
  private func requestAuthorization(completion: @escaping (Bool) -> Void) {
    SFSpeechRecognizer.requestAuthorization { speechStatus in
      guard speechStatus == .authorized else {
        DispatchQueue.main.async { completion(false) }
        return
      }
      AVAudioSession.sharedInstance().requestRecordPermission { micGranted in
        DispatchQueue.main.async { completion(micGranted) }
      }
    }
  }

  private func beginSession(partialResults: Bool) throws {
    // Tear down any prior task.
    recognitionTask?.cancel()
    recognitionTask = nil

    let audioSession = AVAudioSession.sharedInstance()
    try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
    try audioSession.setActive(true, options: .notifyOthersOnDeactivation)

    let request = SFSpeechAudioBufferRecognitionRequest()
    request.shouldReportPartialResults = partialResults
    if #available(iOS 13.0, *) {
      // Prefer on-device recognition when the device supports it for am-ET.
      request.requiresOnDeviceRecognition = recognizer?.supportsOnDeviceRecognition ?? false
    }
    recognitionRequest = request

    let inputNode = audioEngine.inputNode
    recognitionTask = recognizer?.recognitionTask(with: request) { [weak self] result, error in
      guard let self = self else { return }
      if let result = result {
        let confidence = self.averageConfidence(of: result.bestTranscription)
        self.emitResult(
          transcript: result.bestTranscription.formattedString,
          isFinal: result.isFinal,
          confidence: confidence)
        if result.isFinal {
          self.finishAudio()
        }
      }
      if let error = error {
        self.emitError(error)
        self.finishAudio()
      }
    }

    let format = inputNode.outputFormat(forBus: 0)
    inputNode.installTap(onBus: 0, bufferSize: 1024, format: format) { buffer, _ in
      request.append(buffer)
    }

    audioEngine.prepare()
    try audioEngine.start()
    isListening = true
  }

  private func averageConfidence(of transcription: SFTranscription) -> Double? {
    let segments = transcription.segments
    guard !segments.isEmpty else { return nil }
    let total = segments.reduce(0.0) { $0 + Double($1.confidence) }
    return total / Double(segments.count)
  }

  private func stopListening() {
    guard isListening else { return }
    // Ask the request to finish so a final result is delivered, then release
    // the microphone tap.
    recognitionRequest?.endAudio()
    finishAudio()
  }

  private func cancel() {
    guard isListening else { return }
    recognitionTask?.cancel()
    finishAudio()
  }

  private func finishAudio() {
    if audioEngine.isRunning {
      audioEngine.stop()
      audioEngine.inputNode.removeTap(onBus: 0)
    }
    recognitionRequest = nil
    recognitionTask = nil
    isListening = false
    try? AVAudioSession.sharedInstance().setActive(
      false, options: .notifyOthersOnDeactivation)
  }

  // MARK: - Event emission

  private func emitResult(transcript: String, isFinal: Bool, confidence: Double?) {
    DispatchQueue.main.async {
      self.eventSink?([
        "transcript": transcript,
        "isFinal": isFinal,
        "confidence": confidence as Any,
      ])
    }
  }

  private func emitError(_ error: Error) {
    let (code, message) = mapError(error)
    DispatchQueue.main.async {
      self.eventSink?(FlutterError(code: code, message: message, details: nil))
    }
  }

  /// Maps an `SFSpeechRecognizer` / audio error to our stable string code.
  private func mapError(_ error: Error) -> (String, String) {
    let nsError = error as NSError
    // `kAFAssistantErrorDomain` code 203 == "no speech / no match"; 216 == canceled.
    if nsError.domain == "kAFAssistantErrorDomain" {
      switch nsError.code {
      case 203: return ("no_match", "No matching speech was recognized.")
      case 216, 1_110: return ("canceled", "Recognition was canceled.")
      default: break
      }
    }
    if nsError.domain == NSURLErrorDomain {
      return ("network", "A network error occurred during recognition.")
    }
    return ("unknown", nsError.localizedDescription)
  }

  private func flutterError(_ code: String, _ message: String) -> FlutterError {
    FlutterError(code: code, message: message, details: nil)
  }
}

// MARK: - FlutterStreamHandler

extension AmharicSttPlugin: FlutterStreamHandler {
  public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink)
    -> FlutterError?
  {
    eventSink = events
    return nil
  }

  public func onCancel(withArguments arguments: Any?) -> FlutterError? {
    eventSink = nil
    return nil
  }
}
