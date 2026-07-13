import 'package:amharic_stt/amharic_stt.dart';
import 'package:amharic_stt/src/amharic_stt_method_channel.dart';
import 'package:flutter/services.dart' show EventChannel;
import 'package:flutter_test/flutter_test.dart';

/// Tests the event-channel side: transcription events decode into
/// [SpeechResult]s, and stream errors surface as typed [AmharicSttException]s.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final messenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;

  // A fresh platform per test: `results` caches its broadcast stream, and once a
  // stream reaches endOfStream it stays closed — reusing one instance across
  // tests would hand later tests an already-finished stream.
  late MethodChannelAmharicStt platform;
  late EventChannel eventChannel;

  setUp(() {
    platform = MethodChannelAmharicStt();
    eventChannel = platform.eventChannel;
  });

  tearDown(() {
    messenger.setMockStreamHandler(eventChannel, null);
  });

  test('decodes partial then final results in order', () async {
    messenger.setMockStreamHandler(
      eventChannel,
      MockStreamHandler.inline(onListen: (arguments, sink) {
        sink.success({'transcript': 'ሰላ', 'isFinal': false});
        sink.success({'transcript': 'ሰላም', 'isFinal': true, 'confidence': 0.9});
        sink.endOfStream();
      }),
    );

    final results = await platform.results.toList();

    expect(results, hasLength(2));
    expect(results[0].transcript, 'ሰላ');
    expect(results[0].isFinal, isFalse);
    expect(results[0].confidence, isNull);
    expect(results[1].transcript, 'ሰላም');
    expect(results[1].isFinal, isTrue);
    expect(results[1].confidence, closeTo(0.9, 1e-9));
  });

  test('missing fields decode to safe defaults', () async {
    messenger.setMockStreamHandler(
      eventChannel,
      MockStreamHandler.inline(onListen: (arguments, sink) {
        sink.success(<Object?, Object?>{});
        sink.endOfStream();
      }),
    );

    final result = await platform.results.first;
    expect(result.transcript, '');
    expect(result.isFinal, isFalse);
    expect(result.confidence, isNull);
  });

  test('channel error surfaces as a typed AmharicSttException', () async {
    messenger.setMockStreamHandler(
      eventChannel,
      MockStreamHandler.inline(onListen: (arguments, sink) {
        sink.error(
          code: 'locale_unavailable',
          message: 'am-ET not supported',
        );
      }),
    );

    await expectLater(
      platform.results,
      emitsError(isA<AmharicSttException>()
          .having((e) => e.kind, 'kind', AmharicSttErrorKind.localeUnavailable)
          .having((e) => e.message, 'message', 'am-ET not supported')),
    );
  });
}
