// Widget test for the example app.
//
// Real speech recognition can't run in a widget test, so this drives the app
// against the plugin's default platform channel with no native side attached:
// isAvailable() resolves to false, and we assert the app shows its honest
// "not available" message rather than a broken mic.

import 'package:amharic_stt_example/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows unavailable message when Amharic is not supported',
      (tester) async {
    await tester.pumpWidget(const AmharicSttDemo());

    // First frame: availability probe is in flight (spinner animates forever,
    // so we can't pumpAndSettle here).
    expect(find.text('Checking Amharic availability…'), findsOneWidget);

    // With no native platform in the test harness, the isAvailable() channel
    // call resolves to false. The reply lands on a real async turn, so pump in a
    // short loop until the state rebuilds rather than relying on a fixed delay.
    const unavailable =
        'Amharic speech recognition is not available on this device.';
    for (var i = 0; i < 20 && find.text(unavailable).evaluate().isEmpty; i++) {
      await tester.runAsync(() => Future<void>.delayed(Duration.zero));
      await tester.pump();
    }

    expect(find.text(unavailable), findsOneWidget);
    expect(find.byIcon(Icons.mic_off), findsOneWidget);
  });
}
