/// The category of a speech-recognition failure.
///
/// Native platform error codes (Android `SpeechRecognizer.ERROR_*`, iOS
/// `SFSpeechError` / `AVAudioSession` failures) are normalised to these kinds
/// on the native side and delivered to Dart as stable string codes, so callers
/// never have to switch on raw, platform-specific integers.
enum AmharicSttErrorKind {
  /// Microphone (and on iOS, speech-recognition) permission was denied or has
  /// not been granted. The user must grant it in system settings.
  permissionDenied,

  /// The Amharic (`am-ET`) locale is not available for on-device or network
  /// recognition on this device/OS version. [AmharicSpeechRecognizer.isAvailable]
  /// returns `false` in this case; calling `startListening` throws this.
  localeUnavailable,

  /// The platform recognizer is already busy with another request.
  recognizerBusy,

  /// Recognition completed but no speech was matched.
  noMatch,

  /// No speech was detected within the platform's input timeout.
  speechTimeout,

  /// A network error occurred (relevant when the recognizer falls back to a
  /// server-side model rather than on-device recognition).
  network,

  /// An audio capture/recording error occurred.
  audio,

  /// Recognition was cancelled — typically because [AmharicSpeechRecognizer.stopListening]
  /// was called, or the OS interrupted the session.
  canceled,

  /// Speech recognition is not available on this platform at all (e.g. an
  /// unsupported OS version, or a platform without a native recognizer).
  notAvailable,

  /// An unclassified error. Inspect [AmharicSttException.platformCode] and
  /// [AmharicSttException.message] for details.
  unknown,
}

/// A typed error thrown by, or emitted on the results stream of,
/// [AmharicSpeechRecognizer].
///
/// This is the *only* error type the public API surfaces — raw
/// [PlatformException]s from the underlying method/event channels are caught and
/// translated into an [AmharicSttException] with a well-defined [kind].
class AmharicSttException implements Exception {
  const AmharicSttException(
    this.kind, {
    required this.message,
    this.platformCode,
    this.details,
  });

  /// The normalised category of this failure.
  final AmharicSttErrorKind kind;

  /// A human-readable description. Safe to log; not localised.
  final String message;

  /// The original platform-side code, when one was available (e.g. the string
  /// error code sent over the channel, or a raw native code). Useful for
  /// debugging; prefer switching on [kind] for control flow.
  final String? platformCode;

  /// Optional extra platform detail attached to the error.
  final Object? details;

  /// Maps a stable string [code] (as sent by the native side) to an
  /// [AmharicSttErrorKind]. Unknown codes fall back to
  /// [AmharicSttErrorKind.unknown].
  static AmharicSttErrorKind kindFromCode(String code) {
    switch (code) {
      case 'permission_denied':
        return AmharicSttErrorKind.permissionDenied;
      case 'locale_unavailable':
        return AmharicSttErrorKind.localeUnavailable;
      case 'recognizer_busy':
        return AmharicSttErrorKind.recognizerBusy;
      case 'no_match':
        return AmharicSttErrorKind.noMatch;
      case 'speech_timeout':
        return AmharicSttErrorKind.speechTimeout;
      case 'network':
        return AmharicSttErrorKind.network;
      case 'audio':
        return AmharicSttErrorKind.audio;
      case 'canceled':
        return AmharicSttErrorKind.canceled;
      case 'not_available':
        return AmharicSttErrorKind.notAvailable;
      default:
        return AmharicSttErrorKind.unknown;
    }
  }

  @override
  String toString() {
    final code = platformCode == null ? '' : ' (platformCode: $platformCode)';
    return 'AmharicSttException(${kind.name}): $message$code';
  }
}
