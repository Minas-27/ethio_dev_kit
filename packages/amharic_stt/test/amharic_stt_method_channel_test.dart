import 'package:amharic_stt/amharic_stt.dart';
import 'package:amharic_stt/src/amharic_stt_method_channel.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

/// Tests the method-channel side of the plugin against a mocked native handler:
/// the right method names/arguments go out, results come back, and platform
/// errors surface as typed [AmharicSttException]s.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final platform = MethodChannelAmharicStt();
  final channel = platform.methodChannel;
  final messenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;

  final log = <MethodCall>[];

  void mockHandler(Future<Object?>? Function(MethodCall call) handler) {
    messenger.setMockMethodCallHandler(channel, (call) async {
      log.add(call);
      return handler(call);
    });
  }

  tearDown(() {
    messenger.setMockMethodCallHandler(channel, null);
    log.clear();
  });

  group('isAvailable', () {
    test('returns true when the native side reports true', () async {
      mockHandler((_) async => true);
      expect(await platform.isAvailable(), isTrue);
      expect(log.single.method, 'isAvailable');
    });

    test('returns false when the native side reports false', () async {
      mockHandler((_) async => false);
      expect(await platform.isAvailable(), isFalse);
    });

    test('returns false (never throws) on a platform error', () async {
      mockHandler((_) async => throw PlatformException(code: 'boom'));
      expect(await platform.isAvailable(), isFalse);
    });

    test('returns false when no plugin is registered', () async {
      messenger.setMockMethodCallHandler(channel, null);
      expect(await platform.isAvailable(), isFalse);
    });
  });

  group('control methods', () {
    test('startListening sends partialResults argument', () async {
      mockHandler((_) async => null);
      await platform.startListening();
      expect(log.single.method, 'startListening');
      expect(log.single.arguments, {'partialResults': true});
    });

    test('startListening forwards partialResults: false', () async {
      mockHandler((_) async => null);
      await platform.startListening(partialResults: false);
      expect(log.single.arguments, {'partialResults': false});
    });

    test('stopListening and cancel invoke their methods', () async {
      mockHandler((_) async => null);
      await platform.stopListening();
      await platform.cancel();
      expect(log.map((c) => c.method), ['stopListening', 'cancel']);
    });
  });

  group('error translation', () {
    test('maps known platform codes to typed kinds', () async {
      mockHandler((_) async => throw PlatformException(
            code: 'permission_denied',
            message: 'nope',
          ));
      expect(
        () => platform.startListening(),
        throwsA(isA<AmharicSttException>()
            .having((e) => e.kind, 'kind', AmharicSttErrorKind.permissionDenied)
            .having((e) => e.platformCode, 'platformCode', 'permission_denied')
            .having((e) => e.message, 'message', 'nope')),
      );
    });

    test('unknown codes fall back to unknown kind', () async {
      mockHandler((_) async => throw PlatformException(code: 'weird_code'));
      expect(
        () => platform.stopListening(),
        throwsA(isA<AmharicSttException>()
            .having((e) => e.kind, 'kind', AmharicSttErrorKind.unknown)),
      );
    });

    test('missing plugin becomes notAvailable', () async {
      messenger.setMockMethodCallHandler(channel, null);
      expect(
        () => platform.startListening(),
        throwsA(isA<AmharicSttException>()
            .having((e) => e.kind, 'kind', AmharicSttErrorKind.notAvailable)),
      );
    });
  });
}
