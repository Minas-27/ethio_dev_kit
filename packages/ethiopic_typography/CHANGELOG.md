# Changelog

## 0.1.1

- Fixed `pubspec.yaml` metadata issues (description length and URLs) to resolve pub.dev scoring warnings.

## 0.1.0

Initial release.

- Bundled **Manrope** (Latin) and **Noto Sans Ethiopic** (Ge'ez) variable fonts
  under the SIL Open Font License 1.1 — the pairing works fully offline with no
  runtime font fetching.
- `EthioFonts.bilingual()` — a single `TextStyle` with Manrope primary and Noto
  Sans Ethiopic fallback, so mixed English/Amharic strings render correctly with
  no per-widget handling.
- `EthioTextTheme.textTheme()` — a bilingual Material 3 `TextTheme` with optional
  per-role weight overrides (`EthioTextWeights`) and a global size `scale`.
- `EthioTextTheme.style()` — a one-off bilingual `TextStyle` helper.
- `ethioAppTheme()` / `ethioDarkAppTheme()` — one-call bilingual `ThemeData`
  builders for light and dark variants, driven by a seed colour.
- Fonts, weights, and colours configurable while the pairing stays fixed.
- Full unit + widget test suite verifying font resolution for mixed
  English/Amharic text, offline.
