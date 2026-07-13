/// On-device Amharic (`am-ET`) speech-to-text for Flutter.
///
/// A thin, typed wrapper over the platform's native speech recognizer
/// (Android `SpeechRecognizer`, iOS `SFSpeechRecognizer`). It does not bundle a
/// recognition engine, so real Amharic support depends on the device/OS — see
/// [AmharicSpeechRecognizer.isAvailable] and the package README.
library;

export 'src/amharic_speech_recognizer.dart'
    show AmharicSpeechRecognizer, kAmharicLocaleTag;
export 'src/amharic_stt_exception.dart'
    show AmharicSttException, AmharicSttErrorKind;
export 'src/amharic_stt_platform_interface.dart' show AmharicSttPlatform;
export 'src/speech_result.dart' show SpeechResult;
