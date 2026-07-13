import 'package:flutter/material.dart';

import 'ethio_fonts.dart';

/// Optional per-role weight overrides for an [EthioTextTheme]. Any field left
/// null keeps the Material default weight for that role.
///
/// The font *pairing* (Manrope + Noto Sans Ethiopic) is fixed; only weights
/// are configurable here so the visual identity stays consistent.
@immutable
class EthioTextWeights {
  /// Creates a set of optional weight overrides.
  const EthioTextWeights({
    this.display,
    this.headline,
    this.title,
    this.body,
    this.label,
  });

  /// Weight for `displayLarge/Medium/Small`.
  final FontWeight? display;

  /// Weight for `headlineLarge/Medium/Small`.
  final FontWeight? headline;

  /// Weight for `titleLarge/Medium/Small`.
  final FontWeight? title;

  /// Weight for `bodyLarge/Medium/Small`.
  final FontWeight? body;

  /// Weight for `labelLarge/Medium/Small`.
  final FontWeight? label;
}

/// Builds bilingual [TextTheme]s using the fixed Manrope + Noto Sans Ethiopic
/// pairing.
///
/// Every text style in the returned theme uses Manrope for Latin glyphs and
/// automatically falls back to Noto Sans Ethiopic for Ge'ez script, so mixed
/// English/Amharic strings render correctly with no per-widget configuration.
class EthioTextTheme {
  const EthioTextTheme._();

  /// Returns a [TextTheme] where every role is bilingual.
  ///
  /// - [base] is the starting theme to convert. Defaults to the standard
  ///   Material 3 [Typography.material2021] English theme. Pass
  ///   `Theme.of(context).textTheme` to preserve inherited sizing.
  /// - [scale] multiplies every font size (e.g. `1.1` for a slightly larger
  ///   theme). Must be > 0.
  /// - [weights] overrides per-role font weights; null fields keep defaults.
  static TextTheme textTheme({
    TextTheme? base,
    double scale = 1.0,
    EthioTextWeights weights = const EthioTextWeights(),
  }) {
    assert(scale > 0, 'scale must be greater than 0');
    // Default to a *fully merged* Material 3 text theme: `.englishLike` carries
    // the geometry (font sizes and weights) while `.black` carries the colours.
    // Using `.black` alone would yield styles with null sizes/weights.
    final defaultTypography = Typography.material2021();
    final source =
        base ?? defaultTypography.englishLike.merge(defaultTypography.black);

    TextStyle? convert(TextStyle? style, FontWeight? weightOverride) {
      if (style == null) return null;
      final scaled = style.copyWith(
        fontSize: style.fontSize == null ? null : style.fontSize! * scale,
        fontWeight: weightOverride ?? style.fontWeight,
      );
      return EthioFonts.bilingual(textStyle: scaled);
    }

    return TextTheme(
      displayLarge: convert(source.displayLarge, weights.display),
      displayMedium: convert(source.displayMedium, weights.display),
      displaySmall: convert(source.displaySmall, weights.display),
      headlineLarge: convert(source.headlineLarge, weights.headline),
      headlineMedium: convert(source.headlineMedium, weights.headline),
      headlineSmall: convert(source.headlineSmall, weights.headline),
      titleLarge: convert(source.titleLarge, weights.title),
      titleMedium: convert(source.titleMedium, weights.title),
      titleSmall: convert(source.titleSmall, weights.title),
      bodyLarge: convert(source.bodyLarge, weights.body),
      bodyMedium: convert(source.bodyMedium, weights.body),
      bodySmall: convert(source.bodySmall, weights.body),
      labelLarge: convert(source.labelLarge, weights.label),
      labelMedium: convert(source.labelMedium, weights.label),
      labelSmall: convert(source.labelSmall, weights.label),
    );
  }

  /// A single bilingual [TextStyle] for one-off use outside a full theme.
  ///
  /// ```dart
  /// Text('Hello ሰላም', style: EthioTextTheme.style(fontSize: 18));
  /// ```
  static TextStyle style({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    double? letterSpacing,
    double? height,
  }) {
    return EthioFonts.bilingual(
      textStyle: TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
        letterSpacing: letterSpacing,
        height: height,
      ),
    );
  }
}
