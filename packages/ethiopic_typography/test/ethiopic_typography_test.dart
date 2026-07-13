import 'package:ethiopic_typography/ethiopic_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Matches the bundled Noto Sans Ethiopic fallback family in a
/// `fontFamilyFallback` list.
bool _hasEthiopicFallback(List<String>? fallback) =>
    fallback != null && fallback.contains(EthioFonts.ethiopicFamily);

void main() {
  // The fonts are bundled assets, so no network or async font loading happens
  // during tests — every assertion below is fully offline and deterministic.

  group('EthioFonts.bilingual', () {
    test('uses Manrope as the primary family', () {
      final style = EthioFonts.bilingual();
      expect(style.fontFamily, EthioFonts.latinFamily);
      expect(style.fontFamily, contains('Manrope'));
    });

    test('registers Noto Sans Ethiopic as a fallback family', () {
      final style = EthioFonts.bilingual();
      expect(style.fontFamilyFallback, isNotNull);
      expect(
        _hasEthiopicFallback(style.fontFamilyFallback),
        isTrue,
        reason: 'Ge\'ez fallback must be present: '
            '${style.fontFamilyFallback}',
      );
    });

    test('carries through size, weight, and colour', () {
      final style = EthioFonts.bilingual(
        textStyle: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: Color(0xFF112233),
        ),
      );
      expect(style.fontSize, 22);
      expect(style.fontWeight, FontWeight.w700);
      expect(style.color, const Color(0xFF112233));
    });

    test('does not duplicate the Ethiopic fallback family', () {
      final style = EthioFonts.bilingual();
      final ethiopicCount = style.fontFamilyFallback!
          .where((f) => f == EthioFonts.ethiopicFamily)
          .length;
      expect(ethiopicCount, 1);
    });

    test('preserves any pre-existing fallback families', () {
      final style = EthioFonts.bilingual(
        textStyle: const TextStyle(fontFamilyFallback: <String>['Custom']),
      );
      expect(style.fontFamilyFallback, contains('Custom'));
      expect(_hasEthiopicFallback(style.fontFamilyFallback), isTrue);
    });
  });

  group('EthioTextTheme.textTheme', () {
    test('every Material text role is bilingual', () {
      final theme = EthioTextTheme.textTheme();
      final roles = <TextStyle?>[
        theme.displayLarge,
        theme.displayMedium,
        theme.displaySmall,
        theme.headlineLarge,
        theme.headlineMedium,
        theme.headlineSmall,
        theme.titleLarge,
        theme.titleMedium,
        theme.titleSmall,
        theme.bodyLarge,
        theme.bodyMedium,
        theme.bodySmall,
        theme.labelLarge,
        theme.labelMedium,
        theme.labelSmall,
      ];
      expect(roles.every((s) => s != null), isTrue);
      for (final s in roles) {
        expect(s!.fontFamily, EthioFonts.latinFamily);
        expect(_hasEthiopicFallback(s.fontFamilyFallback), isTrue);
      }
    });

    test('scale multiplies every font size', () {
      final normal = EthioTextTheme.textTheme();
      final scaled = EthioTextTheme.textTheme(scale: 2.0);
      expect(
        scaled.bodyLarge!.fontSize,
        closeTo(normal.bodyLarge!.fontSize! * 2.0, 0.001),
      );
      expect(
        scaled.displayLarge!.fontSize,
        closeTo(normal.displayLarge!.fontSize! * 2.0, 0.001),
      );
    });

    test('weight overrides apply per role group', () {
      final theme = EthioTextTheme.textTheme(
        weights: const EthioTextWeights(
          body: FontWeight.w300,
          display: FontWeight.w900,
        ),
      );
      expect(theme.bodyLarge!.fontWeight, FontWeight.w300);
      expect(theme.bodyMedium!.fontWeight, FontWeight.w300);
      expect(theme.displayLarge!.fontWeight, FontWeight.w900);
      // Untouched groups keep a non-null default weight.
      expect(theme.titleLarge!.fontWeight, isNotNull);
    });

    test('asserts on non-positive scale', () {
      expect(
        () => EthioTextTheme.textTheme(scale: 0),
        throwsA(isA<AssertionError>()),
      );
    });
  });

  group('EthioTextTheme.style', () {
    test('produces a bilingual one-off style', () {
      final s = EthioTextTheme.style(fontSize: 18, color: Colors.red);
      expect(s.fontSize, 18);
      expect(s.color, Colors.red);
      expect(s.fontFamily, EthioFonts.latinFamily);
      expect(_hasEthiopicFallback(s.fontFamilyFallback), isTrue);
    });
  });

  group('ethioAppTheme', () {
    test('light theme has bilingual text and light brightness', () {
      final theme = ethioAppTheme();
      expect(theme.brightness, Brightness.light);
      expect(theme.textTheme.bodyLarge!.fontFamily, EthioFonts.latinFamily);
      expect(
        _hasEthiopicFallback(theme.textTheme.bodyLarge!.fontFamilyFallback),
        isTrue,
      );
    });

    test('dark theme has dark brightness and bilingual text', () {
      final theme = ethioDarkAppTheme();
      expect(theme.brightness, Brightness.dark);
      expect(theme.textTheme.titleLarge!.fontFamily, EthioFonts.latinFamily);
    });

    test('uses Material 3', () {
      expect(ethioAppTheme().useMaterial3, isTrue);
    });

    test('respects a custom seed colour', () {
      final theme = ethioAppTheme(seedColor: const Color(0xFF884400));
      expect(theme.colorScheme.brightness, Brightness.light);
    });
  });

  group('Rendering (widget)', () {
    testWidgets('mixed English + Amharic text renders with the theme',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ethioAppTheme(),
          home: const Scaffold(
            body: Center(child: Text('Welcome እንኳን ደህና መጡ')),
          ),
        ),
      );
      final textWidget = tester.widget<Text>(find.byType(Text));
      expect(textWidget.data, 'Welcome እንኳን ደህና መጡ');

      // The effective style resolved from the theme should carry the fallback.
      final richText = tester.widget<RichText>(find.byType(RichText).first);
      final resolved = richText.text.style!;
      expect(resolved.fontFamily, EthioFonts.latinFamily);
      expect(_hasEthiopicFallback(resolved.fontFamilyFallback), isTrue);
    });
  });
}
