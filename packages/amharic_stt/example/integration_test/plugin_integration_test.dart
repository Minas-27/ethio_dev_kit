// Integration test — runs on a real device/emulator against the native plugin.
//
// It can only assert the API contract that doesn't require a human speaking:
// isAvailable() returns a bool without throwing. Real transcription accuracy
// must be checked manually (see the package README "Verification status").

import 'package:amharic_stt/amharic_stt.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('isAvailable returns a bool on the host platform',
      (tester) async {
    final recognizer = AmharicSpeechRecognizer();
    final available = await recognizer.isAvailable();
    expect(available, isA<bool>());
    recognizer.dispose();
  });
}
