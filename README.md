# Ethio Dev Kit

A collection of small, focused Dart and Flutter packages for building apps for
Ethiopia. Each package solves one common, locale-specific problem well
calendar conversion, Amharic typography, input validation, and speech-to-text
so you don't have to re-implement it in every project.

Built for Flutter and Dart developers shipping products for Ethiopian users.
Every package is independently versioned and published to pub.dev, so you can
depend on just the ones you need. Pure-Dart packages have no Flutter dependency
and no third-party runtime dependencies.

## Packages

### ethiopian_calendar

[![pub package](https://img.shields.io/pub/v/ethiopian_calendar.svg)](https://pub.dev/packages/ethiopian_calendar)

Convert between Gregorian and Ethiopian calendar dates, with Amharic month and
day names, formatting, and date arithmetic. Pure Dart, dependency-free.

→ [`packages/ethiopian_calendar`](packages/ethiopian_calendar)

### ethiopic_typography

[![pub package](https://img.shields.io/pub/v/ethiopic_typography.svg)](https://pub.dev/packages/ethiopic_typography)

Drop-in bilingual (English/Amharic) Flutter theming with the Manrope + Noto Sans
Ethiopic font pairing. Latin text renders in Manrope; Ge'ez script falls back to
Noto Sans Ethiopic automatically. Fonts are bundled, so it works fully offline.

→ [`packages/ethiopic_typography`](packages/ethiopic_typography)

### ethio_validators

[![pub package](https://img.shields.io/pub/v/ethio_validators.svg)](https://pub.dev/packages/ethio_validators)

Validation and formatting utilities for Ethiopian data: mobile phone numbers
(Ethio Telecom & Safaricom) and ETB currency. Pure Dart, dependency-free.

→ [`packages/ethio_validators`](packages/ethio_validators)

### amharic_stt

[![pub package](https://img.shields.io/pub/v/amharic_stt.svg)](https://pub.dev/packages/amharic_stt)

On-device Amharic (am-ET) speech-to-text for Flutter. A thin, typed wrapper over
each platform's native speech recognizer (Android `SpeechRecognizer`, iOS
`SFSpeechRecognizer`) with honest availability checks — no custom engine and no
bundled model.

→ [`packages/amharic_stt`](packages/amharic_stt)

## Status

All four packages are at **0.1.0** and verified at the code level.

**`amharic_stt` iOS support is unverified.** The Android implementation compiles
and has been checked; the iOS (Swift / `SFSpeechRecognizer`) path has not yet
been validated on a real device and remains pending device testing. Treat iOS
support as experimental until confirmed. See the package's own README for the
current platform/locale support matrix.

## Getting started

Add the package(s) you need from pub.dev and see each package's own README for
installation details, full API docs, and runnable examples:

- [ethiopian_calendar](packages/ethiopian_calendar/README.md)
- [ethiopic_typography](packages/ethiopic_typography/README.md)
- [ethio_validators](packages/ethio_validators/README.md)
- [amharic_stt](packages/amharic_stt/README.md)

Each package folder also contains an `example/` you can run.

## Contributing

Issues and pull requests are welcome. This repo is a
[Melos](https://melos.invertase.dev/)-managed monorepo — run `melos bootstrap`
to set it up, then use `melos run analyze`, `melos run test`, and
`melos run format-check` across all packages. Please keep changes scoped to a
single package where possible and update that package's `CHANGELOG.md`.

## License

Every package in this repository is licensed under the [MIT License](LICENSE).
