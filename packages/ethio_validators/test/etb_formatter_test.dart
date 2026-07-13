import 'package:ethio_validators/ethio_validators.dart';
import 'package:test/test.dart';

void main() {
  group('EtbFormatter.format (defaults)', () {
    const etb = EtbFormatter();

    test('formats a plain amount with thousands separator and 2 decimals', () {
      expect(etb.format(1250), '1,250.00 ETB');
    });

    test('zero', () {
      expect(etb.format(0), '0.00 ETB');
    });

    test('negative keeps the sign next to the digits', () {
      expect(etb.format(-1250.5), '-1,250.50 ETB');
    });

    test('negative zero does not render a sign', () {
      expect(etb.format(-0.0), '0.00 ETB');
      expect(etb.format(-0.004), '0.00 ETB');
    });

    test('large numbers group every three digits', () {
      expect(etb.format(1234567.89), '1,234,567.89 ETB');
      expect(etb.format(1000000000), '1,000,000,000.00 ETB');
    });

    test('sub-1000 amounts are not grouped', () {
      expect(etb.format(42.5), '42.50 ETB');
      expect(etb.format(7), '7.00 ETB');
    });

    test('rounds to the configured decimal digits', () {
      expect(etb.format(1250.567), '1,250.57 ETB');
      expect(etb.format(1250.564), '1,250.56 ETB');
    });
  });

  group('EtbFormatter.format (configured)', () {
    test('prefix symbol position', () {
      const f = EtbFormatter(symbolPosition: EtbSymbolPosition.prefix);
      expect(f.format(1250), 'ETB 1,250.00');
      expect(f.format(-99.9), 'ETB -99.90');
    });

    test('custom symbol', () {
      const f = EtbFormatter(symbol: 'Br');
      expect(f.format(50), '50.00 Br');
    });

    test('zero decimal digits', () {
      const f = EtbFormatter(decimalDigits: 0);
      expect(f.format(1250.7), '1,251 ETB');
      expect(f.format(999), '999 ETB');
    });

    test('European-style separators', () {
      const f = EtbFormatter(
        thousandsSeparator: '.',
        decimalSeparator: ',',
      );
      expect(f.format(1234567.89), '1.234.567,89 ETB');
    });

    test('asserts when separators collide', () {
      expect(
        () => EtbFormatter(thousandsSeparator: '.', decimalSeparator: '.'),
        throwsA(isA<AssertionError>()),
      );
    });

    test('throws on non-finite input', () {
      const etb = EtbFormatter();
      expect(() => etb.format(double.nan), throwsArgumentError);
      expect(() => etb.format(double.infinity), throwsArgumentError);
    });
  });

  group('EtbFormatter.parse', () {
    const etb = EtbFormatter();

    test('parses a canonical suffix string', () {
      expect(etb.parse('1,250.00 ETB'), 1250.0);
    });

    test('parses a prefix string', () {
      expect(etb.parse('ETB 1,250.50'), 1250.5);
    });

    test('parses a negative amount', () {
      expect(etb.parse('-1,250.00 ETB'), -1250.0);
    });

    test('parses parenthesised negatives', () {
      expect(etb.parse('(1,250.00 ETB)'), -1250.0);
    });

    test('tolerates missing symbol and separators', () {
      expect(etb.parse('1250'), 1250.0);
      expect(etb.parse('  1000000.99  '), 1000000.99);
    });

    test('parses with matching custom separators', () {
      const f = EtbFormatter(
        thousandsSeparator: '.',
        decimalSeparator: ',',
      );
      expect(f.parse('1.234.567,89 ETB'), 1234567.89);
    });

    test('throws FormatException on non-numeric input', () {
      expect(() => etb.parse('not money'), throwsFormatException);
      expect(() => etb.parse(''), throwsFormatException);
    });

    test('tryParse returns null instead of throwing', () {
      expect(etb.tryParse('not money'), isNull);
      expect(etb.tryParse('   '), isNull);
    });
  });

  group('EtbFormatter round-trip', () {
    const suffix = EtbFormatter();
    const prefix = EtbFormatter(symbolPosition: EtbSymbolPosition.prefix);
    const values = <double>[0, 1, 42.5, 1250.0, 1000000.99, -1250.75, -0.5];

    for (final v in values) {
      test('parse(format($v)) == $v — suffix', () {
        expect(suffix.parse(suffix.format(v)), closeTo(v, 1e-9));
      });
      test('parse(format($v)) == $v — prefix', () {
        expect(prefix.parse(prefix.format(v)), closeTo(v, 1e-9));
      });
    }
  });
}
