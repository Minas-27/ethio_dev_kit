# Changelog

## 0.1.0

Initial release.

- `AmharicSpeechRecognizer` — a typed wrapper over the platform's native speech
  recognizer (Android `SpeechRecognizer`, iOS `SFSpeechRecognizer`), fixed to
  the Amharic (`am-ET`) locale. No custom engine and no bundled model.
- `startListening()` / `stopListening()` / `cancel()`, a `Stream<String>`
  (`transcripts`) of partial + final results, and a structured
  `Stream<SpeechResult>` (`results`) with `isFinal` and optional confidence.
- `isAvailable()` that honestly reflects device support: on Android 13+ it
  queries the recognizer's actual supported-language list; it returns `false`
  (never crashes/hangs) when Amharic is unavailable.
- Typed `AmharicSttException` / `AmharicSttErrorKind` — platform errors
  (permission denied, locale unavailable, recognizer busy, no match, timeout,
  network, audio, canceled, not available) are normalised on the native side
  and never leak as raw `PlatformException`s.
- Example app with a mic button, live partial transcription, start/stop
  controls, and a visible message when Amharic isn't available on the device.

### Test coverage & verification

- The automated test suite mocks the method/event channels and verifies the
  **public API contract only**: channel calls/arguments, stream decoding,
  `isAvailable()` true/false logic, and typed-error propagation.
- It does **not** cover real speech recognition. Actual Amharic transcription
  accuracy depends on the platform model and must be verified manually on a
  device.
- The native Android/iOS code is written against the documented platform APIs
  but was **not** compiled or run on a real device/emulator for this release.
  `flutter analyze` and `flutter test` (package + example) are clean/green.
- See the README "Platform & locale support" and "Verification status" sections
  for the current honest state of Amharic support (limited on Android,
  unsupported on iOS at time of writing).
