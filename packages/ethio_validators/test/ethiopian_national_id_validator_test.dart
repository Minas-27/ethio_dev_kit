import 'package:ethio_validators/ethio_validators.dart';
import 'package:test/test.dart';

void main() {
  group('EthiopianNationalIdValidator', () {
    test('isValid accepts valid 12-digit inputs with different formatting', () {
      expect(EthiopianNationalIdValidator.isValid('123456789012'), isTrue);
      expect(EthiopianNationalIdValidator.isValid('1234 5678 9012'), isTrue);
      expect(EthiopianNationalIdValidator.isValid('1234-5678-9012'), isTrue);
      expect(EthiopianNationalIdValidator.isValid(' 123456789012  '), isTrue);
    });

    test('isValid rejects invalid inputs', () {
      expect(EthiopianNationalIdValidator.isValid(''), isFalse);
      expect(EthiopianNationalIdValidator.isValid('12345678901'), isFalse); // 11 digits
      expect(EthiopianNationalIdValidator.isValid('1234567890123'), isFalse); // 13 digits
      expect(EthiopianNationalIdValidator.isValid('12345678901A'), isFalse); // non-numeric
      expect(EthiopianNationalIdValidator.isValid('1234.5678.9012'), isFalse); // dots not allowed
    });

    test('normalize returns clean 12-digit string', () {
      expect(EthiopianNationalIdValidator.normalize('1234 5678 9012'), '123456789012');
      expect(EthiopianNationalIdValidator.normalize('1234-5678-9012'), '123456789012');
      expect(EthiopianNationalIdValidator.normalize('123456789012'), '123456789012');
    });

    test('normalize throws FormatException on invalid input', () {
      expect(
        () => EthiopianNationalIdValidator.normalize('12345678901'),
        throwsFormatException,
      );
    });

    test('tryNormalize returns null on invalid input', () {
      expect(EthiopianNationalIdValidator.tryNormalize('12345678901'), isNull);
      expect(EthiopianNationalIdValidator.tryNormalize('12345678901A'), isNull);
    });

    test('format groups 12 digits correctly', () {
      expect(EthiopianNationalIdValidator.format('123456789012'), '1234 5678 9012');
      expect(EthiopianNationalIdValidator.format('1234 5678 9012'), '1234 5678 9012');
      expect(EthiopianNationalIdValidator.format('1234-5678-9012'), '1234 5678 9012');
    });

    test('format throws FormatException on invalid input', () {
      expect(
        () => EthiopianNationalIdValidator.format('12345678901'),
        throwsFormatException,
      );
    });

    test('round-trip normalize and format', () {
      const rawInput = ' 1234-5678 9012 ';
      final normalized = EthiopianNationalIdValidator.normalize(rawInput);
      expect(normalized, '123456789012');
      final formatted = EthiopianNationalIdValidator.format(normalized);
      expect(formatted, '1234 5678 9012');
      final reNormalized = EthiopianNationalIdValidator.normalize(formatted);
      expect(reNormalized, normalized);
    });
  });
}
