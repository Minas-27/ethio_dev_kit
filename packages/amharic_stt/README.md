# amharic_stt

<!-- Badges: replace <OWNER> once the repo is published, then uncomment. -->
<!--
[![pub package](https://img.shields.io/pub/v/amharic_stt.svg)](https://pub.dev/packages/amharic_stt)
[![CI](https://github.com/<OWNER>/ethio_dev_kit/actions/workflows/ci.yaml/badge.svg)](https://github.com/<OWNER>/ethio_dev_kit/actions/workflows/ci.yaml)
[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
-->

On-device **Amharic (`am-ET`) speech-to-text** for Flutter — a thin, typed
wrapper over each platform's **native** speech recognizer
(Android `SpeechRecognizer`, iOS `SFSpeechRecognizer`).

> **Read this first.** This package does **not** implement its own recognition
> engine and does **not** ship an Amharic model. It asks the OS to recognize
> Amharic. Whether that works depends entirely on the device and OS — and as of
> this release, **Amharic support is limited and, on many devices, absent.**
> See [Platform & locale support](#platform--locale-support) before adopting.

## What this package gives you

- ✅ A clean, typed Dart API — `startListening()`, `stopListening()`, a
  `Stream<String>` of partial + final transcripts, and `isAvailable()`.
- ✅ **Honest availability**: `isAvailable()` returns `false` (rather than
  crashing or hanging) when the device can't recognize Amharic. On Android 13+
  it queries the recognizer's actual supported-language list.
- ✅ **Typed errors** — `AmharicSttException` with an `AmharicSttErrorKind`
  (`permissionDenied`, `localeUnavailable`, `recognizerBusy`, …) instead of raw
  `PlatformException`s leaking through.
- ✅ Wraps the platform recognizer; **no custom engine, no bundled model, no
  network service of our own.**

## Install

```yaml
dependencies:
  amharic_stt: ^0.1.0
```

```dart
import 'package:amharic_stt/amharic_stt.dart';
```

You must also declare the platform permissions below.

## Quick start

```dart
import 'package:amharic_stt/amharic_stt.dart';

final recognizer = AmharicSpeechRecognizer();

Future<void> transcribe() async {
  // 1. Always check first — Amharic may not be supported on this device.
  if (!await recognizer.isAvailable()) {
    // Show "Amharic isn't supported on this device" in your UI.
    return;
  }

  // 2. Listen for partial + final transcripts.
  recognizer.transcripts.listen(
    (text) => print(text),
    onError: (Object e) {
      if (e is AmharicSttException) {
        print('STT failed: ${e.kind} — ${e.message}');
      }
    },
  );

  // 3. Start / stop.
  try {
    await recognizer.startListening();
  } on AmharicSttException catch (e) {
    print('Could not start: ${e.kind}');
  }
  // ...later...
  await recognizer.stopListening();
}
```

Call `recognizer.dispose()` when you're done.

Prefer structured updates? Listen to `recognizer.results` for a
`Stream<SpeechResult>` (`transcript` + `isFinal` + optional `confidence`)
instead of the plain `Stream<String>` `transcripts`.

## API

| Symbol | Description |
| --- | --- |
| `AmharicSpeechRecognizer({platform})` | The main entry point. `platform` is for injecting a fake in tests. |
| `isAvailable()` → `Future<bool>` | Whether `am-ET` recognition is usable now. Never throws. |
| `startListening({partialResults = true})` → `Future<void>` | Begins a session. Throws `AmharicSttException` (`recognizerBusy`, `permissionDenied`, `localeUnavailable`, …). |
| `stopListening()` → `Future<void>` | Stops and requests the final result. No-op if idle. |
| `cancel()` → `Future<void>` | Cancels immediately, discarding any pending result. No-op if idle. |
| `transcripts` → `Stream<String>` | Partial + final transcript text. Errors are `AmharicSttException`. |
| `results` → `Stream<SpeechResult>` | Structured updates (`transcript`, `isFinal`, `confidence`). |
| `isListening` → `bool` | Whether a session is currently active. |
| `dispose()` | Releases resources; the recognizer must not be used afterwards. |
| `SpeechResult` | `{ transcript, isFinal, confidence? }`. |
| `AmharicSttException` | `{ kind, message, platformCode?, details? }`. |
| `AmharicSttErrorKind` | `permissionDenied`, `localeUnavailable`, `recognizerBusy`, `noMatch`, `speechTimeout`, `network`, `audio`, `canceled`, `notAvailable`, `unknown`. |
| `kAmharicLocaleTag` | The requested locale — `'am-ET'`. |

## Platform & locale support

**This is the honest part. Please read it.**

This plugin requests the `am-ET` locale from the platform recognizer. Neither
platform guarantees Amharic, and the reality today is:

| Platform | Native API | Amharic (`am-ET`) status |
| --- | --- | --- |
| **Android** | `SpeechRecognizer` | **Sometimes, device-dependent.** Google's *online* recognition accepts `am-ET`, so devices with Google's speech services and network access may transcribe Amharic. *Offline* support requires a downloaded Amharic language pack, which most devices do not have and which apps cannot install programmatically. Availability varies by device, OEM, and installed recognition service. |
| **iOS** | `SFSpeechRecognizer` | **Not supported at time of writing.** Amharic is not in Apple's `SFSpeechRecognizer.supportedLocales()` (nor in the iOS 26 `SpeechTranscriber` list). `SFSpeechRecognizer(locale: am-ET)` typically returns `nil`, so `isAvailable()` returns `false` and the API fails gracefully. |
| **Web / desktop** | — | Not implemented. `isAvailable()` returns `false`. |

Because support is genuinely uncertain per device, **`isAvailable()` is not
optional** — always call it and design your UI for the `false` case. When it's
`false`, `startListening()` will throw `AmharicSttException` with
`AmharicSttErrorKind.localeUnavailable` (or `notAvailable`) rather than crashing
or hanging.

### Verification status

Full transparency about what has and hasn't been tested:

- ✅ **Dart API + platform-channel contract** — verified by an automated test
  suite that mocks the method/event channels (see [Testing](#testing)). This
  covers method names/arguments, stream decoding, `isAvailable()` true/false
  logic, and typed-error propagation.
- ✅ **`flutter analyze`** clean and **`flutter test`** green for both the
  package and the example app.
- ⚠️ **Native Android/iOS code — NOT device-verified.** The Kotlin and Swift
  implementations are written against the documented platform APIs but have
  **not** been compiled or run on a real device or emulator as part of this
  release. `flutter analyze`/`flutter test` do not build native code.
- ⚠️ **Real Amharic transcription accuracy — NOT verified.** No recorded or live
  Amharic speech has been transcribed through this plugin. Real-world accuracy
  depends on the platform model, not this wrapper, and must be validated on
  target devices before you rely on it.

If you run this on a device, please file an issue reporting your device, OS
version, and whether `isAvailable()` returned `true` — real-world data on
Amharic availability is scarce and valuable.

## Permissions

### Android

The plugin's manifest already declares `RECORD_AUDIO` (and `INTERNET`, since
online recognition may be used). Runtime microphone permission is requested for
you on the first `startListening()`. No extra setup is required in most apps.

### iOS

Add usage descriptions to your app's `Info.plist`:

```xml
<key>NSMicrophoneUsageDescription</key>
<string>This app uses the microphone to transcribe Amharic speech.</string>
<key>NSSpeechRecognitionUsageDescription</key>
<string>This app uses speech recognition to transcribe Amharic speech to text.</string>
```

## Testing

The automated suite (`flutter test`) mocks the platform channels and verifies
the **public API contract**, not real recognition:

- correct method-channel calls and arguments for `startListening` /
  `stopListening` / `cancel` / `isAvailable`;
- event-channel decoding into `SpeechResult` (partial → final, missing-field
  defaults);
- error translation from platform codes to typed `AmharicSttException` kinds;
- `AmharicSpeechRecognizer` state logic — the `recognizerBusy` guard, state
  reset on a failed start, stream mapping, and use-after-`dispose`.

What the suite deliberately does **not** cover: actual audio capture, native
recognizer behaviour, and Amharic transcription accuracy — see
[Verification status](#verification-status).

## Example

A minimal app (mic button, live partial transcription, start/stop controls, and
a visible "not available" message) lives in [`example/`](example/):

```bash
cd example
flutter run
```

## Contributing

Part of the [ethio_dev_kit](https://github.com/abroid-dev/ethio_dev_kit)
monorepo. Issues and pull requests are welcome — please run `flutter analyze`
and `flutter test` (both must be clean/green) before opening a PR. Device
reports on Amharic availability are especially welcome.

## License

MIT — see [`LICENSE`](LICENSE).
