import 'dart:async';

import 'amharic_stt_exception.dart';
import 'amharic_stt_platform_interface.dart';
import 'speech_result.dart';

/// The BCP-47 locale tag this plugin requests from the platform recognizer.
const String kAmharicLocaleTag = 'am-ET';

/// A clean, typed wrapper around the platform's native speech recognizer,
/// fixed to the Amharic (`am-ET`) locale.
///
/// Wraps Android's `SpeechRecognizer` and iOS's `SFSpeechRecognizer` — it does
/// **not** implement its own recognition engine. Whether Amharic actually works
/// depends entirely on the device/OS; always check [isAvailable] first and be
/// ready for a typed [AmharicSttException].
///
/// ```dart
/// final recognizer = AmharicSpeechRecognizer();
/// if (await recognizer.isAvailable()) {
///   recognizer.transcripts.listen(print);
///   await recognizer.startListening();
///   // ...later...
///   await recognizer.stopListening();
/// }
/// recognizer.dispose();
/// ```
class AmharicSpeechRecognizer {
  /// Creates a recognizer. Pass [platform] only in tests to inject a fake.
  AmharicSpeechRecognizer({AmharicSttPlatform? platform})
      : _platform = platform ?? AmharicSttPlatform.instance;

  final AmharicSttPlatform _platform;

  bool _isListening = false;
  bool _disposed = false;

  /// Whether a listening session is currently active.
  bool get isListening => _isListening;

  /// Whether Amharic (`am-ET`) recognition is usable on this device right now.
  ///
  /// Returns `false` — never throws — when the recognizer is missing, disabled,
  /// or does not support the Amharic locale. Call this before [startListening]
  /// and surface an "Amharic not supported on this device" message when it is
  /// `false`.
  Future<bool> isAvailable() {
    _checkNotDisposed();
    return _platform.isAvailable();
  }

  /// A stream of transcription text — both partial (interim) and final.
  ///
  /// This is the spec's `Stream<String>`: each event is the current best
  /// transcript. Use [results] instead if you need to distinguish partial from
  /// final updates. Errors are [AmharicSttException]s.
  Stream<String> get transcripts => results.map((r) => r.transcript);

  /// A stream of structured [SpeechResult]s (transcript + `isFinal` +
  /// confidence). Errors are [AmharicSttException]s.
  Stream<SpeechResult> get results => _platform.results;

  /// Starts an Amharic listening session.
  ///
  /// Transcription updates arrive on [transcripts] / [results].
  ///
  /// Throws an [AmharicSttException] with:
  /// * [AmharicSttErrorKind.recognizerBusy] if a session is already active;
  /// * [AmharicSttErrorKind.localeUnavailable] if Amharic is unsupported;
  /// * [AmharicSttErrorKind.permissionDenied] if microphone/speech permission
  ///   was refused;
  /// * other kinds for audio/network/platform failures.
  ///
  /// Set [partialResults] to `false` to receive only the final transcript.
  Future<void> startListening({bool partialResults = true}) async {
    _checkNotDisposed();
    if (_isListening) {
      throw const AmharicSttException(
        AmharicSttErrorKind.recognizerBusy,
        message: 'Already listening. Call stopListening() before starting a '
            'new session.',
        platformCode: 'recognizer_busy',
      );
    }
    _isListening = true;
    try {
      await _platform.startListening(partialResults: partialResults);
    } catch (_) {
      // Failed to start — we are not actually listening.
      _isListening = false;
      rethrow;
    }
  }

  /// Stops the active session and requests the platform's final result.
  ///
  /// A no-op if not currently listening. Any final result is still delivered on
  /// [transcripts] / [results] before the session ends.
  Future<void> stopListening() async {
    _checkNotDisposed();
    if (!_isListening) return;
    _isListening = false;
    await _platform.stopListening();
  }

  /// Cancels the active session immediately, discarding any pending result.
  ///
  /// A no-op if not currently listening.
  Future<void> cancel() async {
    _checkNotDisposed();
    if (!_isListening) return;
    _isListening = false;
    await _platform.cancel();
  }

  /// Releases resources. After calling this, the recognizer must not be used.
  void dispose() {
    _disposed = true;
    _isListening = false;
  }

  void _checkNotDisposed() {
    if (_disposed) {
      throw StateError('AmharicSpeechRecognizer used after dispose().');
    }
  }
}
