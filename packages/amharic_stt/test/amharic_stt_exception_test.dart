import 'package:amharic_stt/amharic_stt.dart';
import 'package:amharic_stt/src/amharic_stt_exception.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('kindFromCode', () {
    const cases = <String, AmharicSttErrorKind>{
      'permission_denied': AmharicSttErrorKind.permissionDenied,
      'locale_unavailable': AmharicSttErrorKind.localeUnavailable,
      'recognizer_busy': AmharicSttErrorKind.recognizerBusy,
      'no_match': AmharicSttErrorKind.noMatch,
      'speech_timeout': AmharicSttErrorKind.speechTimeout,
      'network': AmharicSttErrorKind.network,
      'audio': AmharicSttErrorKind.audio,
      'canceled': AmharicSttErrorKind.canceled,
      'not_available': AmharicSttErrorKind.notAvailable,
      'something_else': AmharicSttErrorKind.unknown,
    };

    cases.forEach((code, kind) {
      test('"$code" -> ${kind.name}', () {
        expect(AmharicSttException.kindFromCode(code), kind);
      });
    });
  });

  test('toString includes kind and platform code', () {
    const e = AmharicSttException(
      AmharicSttErrorKind.localeUnavailable,
      message: 'am-ET unsupported',
      platformCode: 'locale_unavailable',
    );
    expect(e.toString(), contains('localeUnavailable'));
    expect(e.toString(), contains('am-ET unsupported'));
    expect(e.toString(), contains('locale_unavailable'));
  });
}
