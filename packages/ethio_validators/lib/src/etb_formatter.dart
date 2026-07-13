/// Where the currency symbol sits relative to the amount.
enum EtbSymbolPosition {
  /// Symbol after the amount: `1,250.00 ETB`.
  suffix,

  /// Symbol before the amount: `ETB 1,250.00`.
  prefix,
}

/// Formats and parses Ethiopian Birr (ETB) currency amounts.
///
/// The formatter is immutable and configurable; construct one and reuse it:
///
/// ```dart
/// const etb = EtbFormatter();
/// etb.format(1250);           // '1,250.00 ETB'
/// etb.parse('1,250.00 ETB');  // 1250.0
///
/// const prefixed = EtbFormatter(symbolPosition: EtbSymbolPosition.prefix);
/// prefixed.format(1250);      // 'ETB 1,250.00'
/// ```
class EtbFormatter {
  /// Creates an ETB formatter.
  ///
  /// - [symbol] is the currency label (default `ETB`; `Br` is also common).
  /// - [symbolPosition] places the symbol before or after the amount.
  /// - [decimalDigits] is the number of fraction digits (default `2`).
  /// - [thousandsSeparator] groups the integer part (default `,`).
  /// - [decimalSeparator] separates the fraction (default `.`).
  ///
  /// [thousandsSeparator] and [decimalSeparator] must differ, and
  /// [decimalDigits] must be non-negative.
  const EtbFormatter({
    this.symbol = 'ETB',
    this.symbolPosition = EtbSymbolPosition.suffix,
    this.decimalDigits = 2,
    this.thousandsSeparator = ',',
    this.decimalSeparator = '.',
  })  : assert(decimalDigits >= 0, 'decimalDigits must be non-negative'),
        assert(
          thousandsSeparator != decimalSeparator,
          'thousandsSeparator and decimalSeparator must differ',
        );

  /// The currency label, e.g. `ETB` or `Br`.
  final String symbol;

  /// Whether [symbol] is placed before or after the amount.
  final EtbSymbolPosition symbolPosition;

  /// Number of fraction digits shown by [format].
  final int decimalDigits;

  /// Separator inserted between groups of three integer digits.
  final String thousandsSeparator;

  /// Separator between the integer and fraction parts.
  final String decimalSeparator;

  /// Formats [value] as an ETB currency string.
  ///
  /// Negatives keep the sign adjacent to the digits (`-1,250.00 ETB`); zero
  /// renders as `0.00 ETB`. [value] is rounded to [decimalDigits].
  String format(num value) {
    if (value.isNaN || value.isInfinite) {
      throw ArgumentError.value(value, 'value', 'must be finite');
    }
    // toStringAsFixed rounds half-away-from-zero and never uses exponents.
    final fixed = value.abs().toStringAsFixed(decimalDigits);
    // Avoid a bogus "-0.00": treat both -0.0 and values that round to zero as
    // non-negative.
    final negative = value.isNegative && double.parse(fixed) != 0;
    final dotIndex = fixed.indexOf('.');
    final intPart = dotIndex == -1 ? fixed : fixed.substring(0, dotIndex);
    final fracPart = dotIndex == -1 ? '' : fixed.substring(dotIndex + 1);

    final grouped = _group(intPart);
    final number =
        fracPart.isEmpty ? grouped : '$grouped$decimalSeparator$fracPart';
    final signed = negative ? '-$number' : number;

    return switch (symbolPosition) {
      EtbSymbolPosition.suffix => '$signed $symbol',
      EtbSymbolPosition.prefix => '$symbol $signed',
    };
  }

  /// Parses an ETB-formatted [input] back into a number.
  ///
  /// Accepts strings produced by [format] as well as looser input: the symbol,
  /// thousands separators, and surrounding whitespace are all optional. Throws
  /// a [FormatException] if no numeric amount can be read. Use [tryParse] for a
  /// non-throwing variant.
  num parse(String input) {
    final result = tryParse(input);
    if (result == null) {
      throw FormatException('Not a valid ETB amount', input);
    }
    return result;
  }

  /// Like [parse], but returns `null` instead of throwing on invalid input.
  double? tryParse(String input) {
    final trimmed = input.trim();
    if (trimmed.isEmpty) return null;

    // Sign must be detected before non-numeric characters are stripped.
    final negative = trimmed.contains('-') ||
        (trimmed.startsWith('(') && trimmed.endsWith(')'));

    var s = trimmed.replaceAll(thousandsSeparator, '');
    if (decimalSeparator != '.') {
      s = s.replaceAll(decimalSeparator, '.');
    }
    // Drop everything that isn't a digit or the decimal point (symbol, sign,
    // parentheses, stray spaces).
    final cleaned = s.replaceAll(RegExp('[^0-9.]'), '');
    if (cleaned.isEmpty || cleaned == '.') return null;

    final magnitude = double.tryParse(cleaned);
    if (magnitude == null) return null;
    return negative ? -magnitude : magnitude;
  }

  /// Inserts [thousandsSeparator] every three digits from the right.
  String _group(String digits) {
    final buffer = StringBuffer();
    final length = digits.length;
    for (var i = 0; i < length; i++) {
      if (i > 0 && (length - i) % 3 == 0) {
        buffer.write(thousandsSeparator);
      }
      buffer.write(digits[i]);
    }
    return buffer.toString();
  }
}
