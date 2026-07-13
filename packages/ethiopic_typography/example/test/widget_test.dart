import 'package:ethiopic_typography_example/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders bilingual demo and toggles theme', (tester) async {
    await tester.pumpWidget(const EthioTypographyDemo());

    // Mixed English + Amharic content is present.
    expect(find.text('Display — ማሳያ'), findsOneWidget);
    expect(find.text('ሰላም ለዓለም — Hello, world!'), findsOneWidget);

    // Starts in light mode; the toggle switches to dark.
    MaterialApp app = tester.widget(find.byType(MaterialApp));
    expect(app.themeMode, ThemeMode.light);

    await tester.tap(find.byIcon(Icons.dark_mode));
    await tester.pumpAndSettle();

    app = tester.widget(find.byType(MaterialApp));
    expect(app.themeMode, ThemeMode.dark);
  });
}
