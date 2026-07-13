import 'dart:async';

import 'package:amharic_stt/amharic_stt.dart';
import 'package:flutter_test/flutter_test.dart';

/// A fake platform implementation that records calls and lets the test push
/// results/errors onto the stream — no method channel involved.
class FakeAmharicSttPlatform extends AmharicSttPlatform {
  FakeAmharicSttPlatform({this.available = true});

  bool available;
  final List<String> calls = <String>[];
  final List<bool> startPartialArgs = <bool>[];
  Object? startError;

  final StreamController<SpeechResult> _controller =
      StreamController<SpeechResult>.broadcast();

  void emit(SpeechResult result) => _controller.add(result);
  void emitError(Object error) => _controller.addError(error);

  @override
  Future<bool> isAvailable() async {
    calls.add('isAvailable');
    return available;
  }

  @override
  Future<void> startListening({bool partialResults = true}) async {
    calls.add('startListening');
    startPartialArgs.add(partialResults);
    if (startError != null) throw startError!;
  }

  @override
  Future<void> stopListening() async => calls.add('stopListening');

  @override
  Future<void> cancel() async => calls.add('cancel');

  @override
  Stream<SpeechResult> get results => _controller.stream;
}

void main() {
  late FakeAmharicSttPlatform fake;
  late AmharicSpeechRecognizer recognizer;

  setUp(() {
    fake = FakeAmharicSttPlatform();
    recognizer = AmharicSpeechRecognizer(platform: fake);
  });

  test('isAvailable delegates to the platform', () async {
    expect(await recognizer.isAvailable(), isTrue);
    fake.available = false;
    expect(await recognizer.isAvailable(), isFalse);
    expect(fake.calls, ['isAvailable', 'isAvailable']);
  });

  test('startListening forwards to the platform and sets isListening',
      () async {
    expect(recognizer.isListening, isFalse);
    await recognizer.startListening();
    expect(recognizer.isListening, isTrue);
    expect(fake.calls, ['startListening']);
    expect(fake.startPartialArgs.single, isTrue);
  });

  test('partialResults flag is forwarded', () async {
    await recognizer.startListening(partialResults: false);
    expect(fake.startPartialArgs.single, isFalse);
  });

  test('starting while already listening throws recognizerBusy', () async {
    await recognizer.startListening();
    expect(
      () => recognizer.startListening(),
      throwsA(isA<AmharicSttException>()
          .having((e) => e.kind, 'kind', AmharicSttErrorKind.recognizerBusy)),
    );
    // The second (rejected) attempt did not reach the platform.
    expect(fake.calls, ['startListening']);
  });

  test('a failed start resets listening state and rethrows typed error',
      () async {
    fake.startError = const AmharicSttException(
      AmharicSttErrorKind.permissionDenied,
      message: 'denied',
    );
    await expectLater(
      recognizer.startListening(),
      throwsA(isA<AmharicSttException>()
          .having((e) => e.kind, 'kind', AmharicSttErrorKind.permissionDenied)),
    );
    expect(recognizer.isListening, isFalse);
    // A retry is allowed because state was reset.
    fake.startError = null;
    await recognizer.startListening();
    expect(recognizer.isListening, isTrue);
  });

  test('stopListening is a no-op when not listening', () async {
    await recognizer.stopListening();
    expect(fake.calls, isEmpty);
  });

  test('stopListening stops an active session', () async {
    await recognizer.startListening();
    await recognizer.stopListening();
    expect(recognizer.isListening, isFalse);
    expect(fake.calls, ['startListening', 'stopListening']);
  });

  test('cancel stops an active session', () async {
    await recognizer.startListening();
    await recognizer.cancel();
    expect(recognizer.isListening, isFalse);
    expect(fake.calls, ['startListening', 'cancel']);
  });

  test('transcripts stream exposes transcript strings (partial + final)',
      () async {
    final received = <String>[];
    final sub = recognizer.transcripts.listen(received.add);

    fake.emit(const SpeechResult(transcript: 'ሰላ', isFinal: false));
    fake.emit(const SpeechResult(transcript: 'ሰላም', isFinal: true));
    await Future<void>.delayed(Duration.zero);

    expect(received, ['ሰላ', 'ሰላም']);
    await sub.cancel();
  });

  test('results stream exposes structured SpeechResults', () async {
    final received = <SpeechResult>[];
    final sub = recognizer.results.listen(received.add);

    fake.emit(
        const SpeechResult(transcript: 'ሰላም', isFinal: true, confidence: 0.8));
    await Future<void>.delayed(Duration.zero);

    expect(received.single.transcript, 'ሰላም');
    expect(received.single.isFinal, isTrue);
    expect(received.single.confidence, 0.8);
    await sub.cancel();
  });

  test('stream errors propagate as AmharicSttException', () async {
    final errors = <Object>[];
    final sub = recognizer.results.listen(
      (_) {},
      onError: errors.add,
    );

    fake.emitError(const AmharicSttException(
      AmharicSttErrorKind.noMatch,
      message: 'no match',
    ));
    await Future<void>.delayed(Duration.zero);

    expect(errors.single, isA<AmharicSttException>());
    await sub.cancel();
  });

  test('using the recognizer after dispose throws StateError', () async {
    recognizer.dispose();
    expect(() => recognizer.isAvailable(), throwsStateError);
    expect(() => recognizer.startListening(), throwsStateError);
  });
}
