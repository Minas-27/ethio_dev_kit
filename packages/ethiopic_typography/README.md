# ethiopic_typography

<!-- Badges: replace Minas-27 once the repo is published, then uncomment. -->
<!--
[![pub package](https://img.shields.io/pub/v/ethiopic_typography.svg)](https://pub.dev/packages/ethiopic_typography)
[![CI](https://github.com/Minas-27/ethio_dev_kit/actions/workflows/ci.yaml/badge.svg)](https://github.com/Minas-27/ethio_dev_kit/actions/workflows/ci.yaml)
[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
-->

Drop-in bilingual (**English / Amharic**) Flutter theming built on the
**Manrope + Noto Sans Ethiopic** font pairing.

Latin text renders in Manrope; Ge'ez script automatically falls back to Noto
Sans Ethiopic — **no per-widget font handling required**. Both families are
**bundled** with the package (SIL Open Font License 1.1), so the pairing works
fully offline with no runtime font fetching.

## Features

- ✅ One-call bilingual `ThemeData` — `ethioAppTheme()` / `ethioDarkAppTheme()`.
- ✅ Automatic per-glyph fallback: English → Manrope, Amharic/Ge'ez → Noto Sans
  Ethiopic, in the same string, with no manual font switching.
- ✅ Bundled variable fonts — offline, deterministic, no network dependency.
- ✅ Light and dark variants from a single seed colour.
- ✅ Configurable base font `scale` and per-role `FontWeight`s, while the font
  pairing stays fixed for a consistent visual identity.
- ✅ `EthioTextTheme.style()` for one-off bilingual `TextStyle`s.

## Install

```yaml
dependencies:
  ethiopic_typography: ^0.1.0
```

Then:

```dart
import 'package:ethiopic_typography/ethiopic_typography.dart';
```

## Quick start

Wire the theme into your `MaterialApp` once — every widget that reads text
styles from the theme becomes bilingual automatically:

```dart
import 'package:flutter/material.dart';
import 'package:ethiopic_typography/ethiopic_typography.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ethioAppTheme(seedColor: const Color(0xFF117A3D)),
      darkTheme: ethioDarkAppTheme(seedColor: const Color(0xFF117A3D)),
      themeMode: ThemeMode.system,
      home: const Scaffold(
        body: Center(
          // Mixed script — no per-widget font handling.
          child: Text('Welcome — እንኳን ደህና መጡ'),
        ),
      ),
    );
  }
}
```

### One-off styles

```dart
Text('Hello ሰላም', style: EthioTextTheme.style(fontSize: 18));
```

### Customising size and weight

The font *pairing* is fixed by design, but sizes and weights are configurable:

```dart
ethioAppTheme(
  seedColor: Colors.indigo,
  textScale: 1.1, // 10% larger everywhere
  weights: const EthioTextWeights(
    display: FontWeight.w800,
    body: FontWeight.w400,
  ),
);
```

## API

| Symbol | Description |
| --- | --- |
| `ethioAppTheme({seedColor, brightness, textScale, weights, colorScheme})` | Builds a bilingual Material 3 `ThemeData`. |
| `ethioDarkAppTheme({seedColor, textScale, weights, colorScheme})` | Convenience for `ethioAppTheme(brightness: Brightness.dark)`. |
| `EthioTextTheme.textTheme({base, scale, weights})` | Builds a bilingual `TextTheme` from any base theme. |
| `EthioTextTheme.style({fontSize, fontWeight, color, letterSpacing, height})` | A single bilingual `TextStyle` for one-off use. |
| `EthioTextWeights({display, headline, title, body, label})` | Optional per-role weight overrides; null fields keep Material defaults. |
| `EthioFonts.bilingual({textStyle})` | Low-level helper: applies the Manrope + Noto Sans Ethiopic pairing to a `TextStyle`. |
| `EthioFonts.latinFamily` / `EthioFonts.ethiopicFamily` | The bundled family references. |

## How the fallback works

`EthioFonts.bilingual()` sets Manrope as the primary `fontFamily` and adds Noto
Sans Ethiopic to `fontFamilyFallback`. Flutter's text engine resolves each glyph
against the primary family first and falls back to the next family when a
codepoint is missing — so Latin characters use Manrope and Ge'ez characters use
Noto Sans Ethiopic within the same run of text.

## Example

A runnable example app (mixed English + Amharic screen with a light/dark toggle)
lives in [`example/`](example/). Run it with:

```bash
cd example
flutter run
```

## Fonts & licensing

The bundled fonts are distributed under the **SIL Open Font License 1.1**:

- **Manrope** — © 2018 The Manrope Project Authors. See
  [`fonts/OFL-Manrope.txt`](fonts/OFL-Manrope.txt).
- **Noto Sans Ethiopic** — © 2022 The Noto Project Authors. See
  [`fonts/OFL-NotoSansEthiopic.txt`](fonts/OFL-NotoSansEthiopic.txt).

The package's own source code is MIT licensed (see [`LICENSE`](LICENSE)). The OFL
covers the font binaries only.

## Contributing

Part of the [ethio_dev_kit](https://github.com/Minas-27/ethio_dev_kit)
monorepo. Issues and pull requests are welcome — please run `flutter analyze` and
`flutter test` (both must be clean/green) before opening a PR.
