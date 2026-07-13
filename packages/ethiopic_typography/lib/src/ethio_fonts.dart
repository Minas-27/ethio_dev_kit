import 'package:flutter/widgets.dart';

/// Low-level font helpers that combine **Manrope** (Latin) with **Noto Sans
/// Ethiopic** (Ge'ez script) into a single [TextStyle] with automatic
/// per-glyph fallback.
///
/// Both families are **bundled with this package** as variable fonts (SIL Open
/// Font License 1.1), so the pairing works fully offline — there is no runtime
/// font fetching. The pairing is fixed by design: Manrope is always the primary
/// family, and Noto Sans Ethiopic is always registered as the fallback.
/// Flutter's text engine resolves each glyph against the primary family first
/// and falls back to the next family when a codepoint is missing — so mixed
/// English/Amharic strings render correctly without any per-widget handling.
class EthioFonts {
  const EthioFonts._();

  /// Package name, used to build the asset-qualified family references below.
  static const String _package = 'ethiopic_typography';

  /// The family reference for the bundled Manrope font.
  ///
  /// Fonts shipped inside a package must be referenced with the
  /// `packages/<package>/<family>` prefix from outside their own package, which
  /// this constant encodes so it is correct wherever it is used.
  static const String latinFamily = 'packages/$_package/Manrope';

  /// The family reference for the bundled Noto Sans Ethiopic font.
  static const String ethiopicFamily = 'packages/$_package/Noto Sans Ethiopic';

  /// Builds a bilingual [TextStyle]: Manrope primary, Noto Sans Ethiopic
  /// fallback, carrying over any provided [textStyle] attributes (size,
  /// weight, colour, spacing, etc.).
  ///
  /// Prefer passing size/weight/colour through [textStyle] so the returned
  /// style is a faithful bilingual version of an existing style.
  static TextStyle bilingual({TextStyle? textStyle}) {
    final base = textStyle ?? const TextStyle();
    final existingFallback = base.fontFamilyFallback ?? const <String>[];
    return base.copyWith(
      fontFamily: latinFamily,
      fontFamilyFallback: <String>[
        ...existingFallback,
        if (!existingFallback.contains(ethiopicFamily)) ethiopicFamily,
      ],
    );
  }
}
