import 'package:ethio_validators/ethio_validators.dart';
import 'package:test/test.dart';

void main() {
  group('EthiopianPhoneValidator.isValid', () {
    group('accepts every input format for Ethio Telecom (9…)', () {
      const cases = [
        '0911234567',
        '251911234567',
        '+251911234567',
        '911234567',
        // With separator noise.
        '091 123 4567',
        '+251 91 123 4567',
        '0911-234-567',
        '(0911) 234 567',
      ];
      for (final c in cases) {
        test('"$c"', () => expect(EthiopianPhoneValidator.isValid(c), isTrue));
      }
    });

    group('accepts every input format for Safaricom (7…)', () {
      const cases = [
        '0711234567',
        '251711234567',
        '+251711234567',
        '711234567',
        '071 123 4567',
        '+251 71 123 4567',
      ];
      for (final c in cases) {
        test('"$c"', () => expect(EthiopianPhoneValidator.isValid(c), isTrue));
      }
    });

    group('rejects invalid numbers', () {
      const cases = {
        'empty': '',
        'blank': '   ',
        'letters': 'not a phone',
        'too short': '091123456',
        'too long': '09112345678',
        'wrong carrier digit (0)': '0011234567',
        'wrong carrier digit (5)': '0511234567',
        'landline (011…)': '0111234567',
        'wrong country code': '+1911234567',
        'country code, wrong length': '+25191123456',
        'plus without country code': '+911234567',
        'nsn wrong leading digit': '811234567',
      };
      cases.forEach((label, value) {
        test(label, () {
          expect(EthiopianPhoneValidator.isValid(value), isFalse);
        });
      });
    });
  });

  group('EthiopianPhoneValidator.carrierOf', () {
    test('detects Ethio Telecom for 9…', () {
      expect(
        EthiopianPhoneValidator.carrierOf('0911234567'),
        EthiopianCarrier.ethioTelecom,
      );
    });

    test('detects Safaricom for 7…', () {
      expect(
        EthiopianPhoneValidator.carrierOf('+251711234567'),
        EthiopianCarrier.safaricom,
      );
    });

    test('returns null for invalid input', () {
      expect(EthiopianPhoneValidator.carrierOf('0111234567'), isNull);
    });
  });

  group('EthiopianPhoneValidator.normalize', () {
    test('every accepted form normalizes to the same E.164 value', () {
      const forms = [
        '0911234567',
        '251911234567',
        '+251911234567',
        '911234567',
        '091 123 4567',
        '+251-91-123-4567',
      ];
      for (final form in forms) {
        expect(
          EthiopianPhoneValidator.normalize(form),
          '+251911234567',
          reason: 'normalize("$form")',
        );
      }
    });

    test('throws FormatException on invalid input', () {
      expect(
        () => EthiopianPhoneValidator.normalize('0111234567'),
        throwsFormatException,
      );
    });

    test('tryNormalize returns null on invalid input', () {
      expect(EthiopianPhoneValidator.tryNormalize('nope'), isNull);
    });
  });

  group('EthiopianPhoneValidator.format', () {
    test('local is the canonical default', () {
      expect(EthiopianPhoneValidator.format('+251911234567'), '0911 234 567');
    });

    test('international form', () {
      expect(
        EthiopianPhoneValidator.format(
          '0911234567',
          format: PhoneNumberFormat.international,
        ),
        '+251 911 234 567',
      );
    });

    test('e164 form', () {
      expect(
        EthiopianPhoneValidator.format(
          '091 123 4567',
          format: PhoneNumberFormat.e164,
        ),
        '+251911234567',
      );
    });

    test('Safaricom number formats with a 0-trunk locally', () {
      expect(EthiopianPhoneValidator.format('711234567'), '0711 234 567');
    });

    test('throws FormatException on invalid input', () {
      expect(
        () => EthiopianPhoneValidator.format('123'),
        throwsFormatException,
      );
    });

    test('round-trips: format(local) is still valid and normalizes back', () {
      const original = '+251911234567';
      final local = EthiopianPhoneValidator.format(original);
      expect(EthiopianPhoneValidator.isValid(local), isTrue);
      expect(EthiopianPhoneValidator.normalize(local), original);
    });
  });
}
