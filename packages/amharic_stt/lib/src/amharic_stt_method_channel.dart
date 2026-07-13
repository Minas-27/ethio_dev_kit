import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'amharic_stt_exception.dart';
import 'amharic_stt_platform_interface.dart';
import 'speech_result.dart';

/// The default [AmharicSttPlatform] implementation, backed by a control
/// [MethodChannel] and a results [EventChannel].
///
/// Channel contract (shared with the native Android/iOS code):
///
/// * Method channel `com.abroid.amharic_stt/methods`
///   - `isAvailable` → `bool`
///   - `startListening` (`{partialResults: bool}`) → `null`
///   - `stopListening` → `null`
///   - `cancel` → `null`
/// * Event channel `com.abroid.amharic_stt/results`
///   - `onListen` argument: `{partialResults: bool}` (mirrors `startListening`)
///   - events: `{transcript: String, isFinal: bool, confidence: double?}`
///   - errors: `FlutterError(code, message, details)` where `code` is one of the
///     stable strings mapped by [AmharicSttException.kindFromCode].
class MethodChannelAmharicStt extends AmharicSttPlatform {
  /// Control channel for one-shot method calls.
  @visibleForTesting
  final MethodChannel methodChannel =
      const MethodChannel('com.abroid.amharic_stt/methods');

  /// Streaming channel for transcription updates.
  @visibleForTesting
  final EventChannel eventChannel =
      const EventChannel('com.abroid.amharic_stt/results');

  Stream<SpeechResult>? _results;

  @override
  Future<bool> isAvailable() async {
    try {
      final available = await methodChannel.invokeMethod<bool>('isAvailable');
      return available ?? false;
    } on PlatformException catch (e) {
      // Availability probing must never throw — an error here means "not
      // available", by definition.
      debugPrint('amharic_stt: isAvailable failed: ${e.code} ${e.message}');
      return false;
    } on MissingPluginException {
      // Platform has no implementation registered (e.g. web/desktop).
      return false;
    }
  }

  @override
  Future<void> startListening({bool partialResults = true}) {
    return _invoke('startListening', <String, dynamic>{
      'partialResults': partialResults,
    });
  }

  @override
  Future<void> stopListening() => _invoke('stopListening');

  @override
  Future<void> cancel() => _invoke('cancel');

  @override
  Stream<SpeechResult> get results {
    return _results ??= eventChannel
        .receiveBroadcastStream()
        .map(_decodeEvent)
        .handleError(_rethrowAsTyped);
  }

  Future<void> _invoke(String method, [Object? arguments]) async {
    try {
      await methodChannel.invokeMethod<void>(method, arguments);
    } on PlatformException catch (e) {
      throw _toTyped(e);
    } on MissingPluginException {
      throw const AmharicSttException(
        AmharicSttErrorKind.notAvailable,
        message: 'The amharic_stt plugin is not available on this platform.',
        platformCode: 'missing_plugin',
      );
    }
  }

  static SpeechResult _decodeEvent(Object? event) {
    final map = (event as Map?)?.cast<Object?, Object?>() ?? const {};
    final confidence = map['confidence'];
    return SpeechResult(
      transcript: (map['transcript'] as String?) ?? '',
      isFinal: (map['isFinal'] as bool?) ?? false,
      confidence: confidence is num ? confidence.toDouble() : null,
    );
  }

  /// Converts a channel error into an [AmharicSttException] and rethrows it, so
  /// listeners on [results] receive the typed error rather than a
  /// [PlatformException].
  static Never _rethrowAsTyped(Object error, StackTrace stackTrace) {
    if (error is PlatformException) {
      throw _toTyped(error);
    }
    if (error is AmharicSttException) {
      throw error;
    }
    throw AmharicSttException(
      AmharicSttErrorKind.unknown,
      message: error.toString(),
    );
  }

  static AmharicSttException _toTyped(PlatformException e) {
    return AmharicSttException(
      AmharicSttException.kindFromCode(e.code),
      message: e.message ?? 'Speech recognition failed.',
      platformCode: e.code,
      details: e.details,
    );
  }
}
