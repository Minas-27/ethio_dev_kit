import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'amharic_stt_method_channel.dart';
import 'speech_result.dart';

/// The interface every platform implementation of `amharic_stt` must satisfy.
///
/// The default implementation, [MethodChannelAmharicStt], talks to the native
/// side over a [MethodChannel] (control) and an [EventChannel] (results). Tests
/// swap in a fake by assigning [instance].
abstract class AmharicSttPlatform extends PlatformInterface {
  AmharicSttPlatform() : super(token: _token);

  static final Object _token = Object();

  static AmharicSttPlatform _instance = MethodChannelAmharicStt();

  /// The active platform implementation.
  static AmharicSttPlatform get instance => _instance;

  static set instance(AmharicSttPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// Whether Amharic (`am-ET`) recognition is actually usable on this device
  /// right now — the native recognizer exists, is enabled, and reports the
  /// Amharic locale as supported.
  Future<bool> isAvailable() {
    throw UnimplementedError('isAvailable() has not been implemented.');
  }

  /// Begins an Amharic listening session.
  ///
  /// Implementations must translate native failures into an
  /// `AmharicSttException` rather than letting a raw platform error escape.
  Future<void> startListening({bool partialResults = true}) {
    throw UnimplementedError('startListening() has not been implemented.');
  }

  /// Stops the current session and asks the platform to deliver its final
  /// result (if any).
  Future<void> stopListening() {
    throw UnimplementedError('stopListening() has not been implemented.');
  }

  /// Cancels the current session immediately, discarding any pending result.
  Future<void> cancel() {
    throw UnimplementedError('cancel() has not been implemented.');
  }

  /// The stream of transcription updates for the active session.
  ///
  /// Errors on this stream are `AmharicSttException`s.
  Stream<SpeechResult> get results {
    throw UnimplementedError('results has not been implemented.');
  }
}
