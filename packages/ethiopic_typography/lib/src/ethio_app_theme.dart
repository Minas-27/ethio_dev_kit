import 'package:flutter/material.dart';

import 'ethio_text_theme.dart';

/// One-call bilingual [ThemeData] builders using the fixed Manrope + Noto Sans
/// Ethiopic pairing.
///
/// ```dart
/// MaterialApp(
///   theme: ethioAppTheme(seedColor: Colors.green),
///   darkTheme: ethioDarkAppTheme(seedColor: Colors.green),
///   themeMode: ThemeMode.system,
/// );
/// ```
///
/// The returned theme applies a fully bilingual [TextTheme]; every widget that
/// reads text styles from the theme renders English in Manrope and Amharic in
/// Noto Sans Ethiopic automatically.
ThemeData ethioAppTheme({
  Color seedColor = const Color(0xFF117A3D),
  Brightness brightness = Brightness.light,
  double textScale = 1.0,
  EthioTextWeights weights = const EthioTextWeights(),
  ColorScheme? colorScheme,
}) {
  final scheme = colorScheme ??
      ColorScheme.fromSeed(seedColor: seedColor, brightness: brightness);

  // Base theme first, so we convert its (correctly coloured) text theme into
  // the bilingual version — this preserves onSurface colours for each role.
  final base = ThemeData(
    colorScheme: scheme,
    useMaterial3: true,
    brightness: scheme.brightness,
  );

  final bilingualText = EthioTextTheme.textTheme(
    base: base.textTheme,
    scale: textScale,
    weights: weights,
  );

  return base.copyWith(
    textTheme: bilingualText,
    primaryTextTheme: EthioTextTheme.textTheme(
      base: base.primaryTextTheme,
      scale: textScale,
      weights: weights,
    ),
  );
}

/// Convenience for a dark bilingual theme; equivalent to calling
/// [ethioAppTheme] with `brightness: Brightness.dark`.
ThemeData ethioDarkAppTheme({
  Color seedColor = const Color(0xFF117A3D),
  double textScale = 1.0,
  EthioTextWeights weights = const EthioTextWeights(),
  ColorScheme? colorScheme,
}) {
  return ethioAppTheme(
    seedColor: seedColor,
    brightness: Brightness.dark,
    textScale: textScale,
    weights: weights,
    colorScheme: colorScheme,
  );
}
