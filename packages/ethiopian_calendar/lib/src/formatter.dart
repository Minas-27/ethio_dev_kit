import 'ethiopian_date.dart';

/// Formats an [EthiopianDate] using a small set of pattern tokens, inspired by
/// (but not identical to) `DateFormat` patterns.
///
/// Supported tokens:
///
/// | Token  | Meaning                        | Example (Hamle 2, 2018) |
/// |--------|--------------------------------|-------------------------|
/// | `yyyy` | Zero-padded 4-digit year       | `2018`                  |
/// | `yy`   | 2-digit year                   | `18`                    |
/// | `MMMM` | Full month name (locale-aware) | `Hamle` / `ሐምሌ`         |
/// | `MM`   | Zero-padded month number       | `11`                    |
/// | `M`    | Month number                   | `11`                    |
/// | `dd`   | Zero-padded day                | `02`                    |
/// | `d`    | Day                            | `2`                     |
/// | `EEEE` | Full weekday name (locale)     | `Thursday` / `ሐሙስ`      |
///
/// Any character sequence wrapped in single quotes is emitted literally, and
/// `''` produces a literal single quote. Unrecognised characters pass through
/// unchanged, so separators like `/`, `-`, `,` and spaces work as written.
class EthiopianDateFormatter {
  /// Creates a formatter for the given [pattern].
  const EthiopianDateFormatter(this.pattern);

  /// The pattern string, e.g. `dd/MM/yyyy` or `MMMM d, yyyy`.
  final String pattern;

  // Recognised tokens, longest first so `MMMM` wins over `MM`/`M`.
  static const List<String> _tokens = <String>[
    'yyyy',
    'EEEE',
    'MMMM',
    'yy',
    'MM',
    'dd',
    'M',
    'd',
  ];

  /// Formats [date] according to [pattern] in the given [locale].
  String format(
    EthiopianDate date, {
    EthiopianDateLocale locale = EthiopianDateLocale.english,
  }) {
    final buffer = StringBuffer();
    var i = 0;
    while (i < pattern.length) {
      final char = pattern[i];

      // Handle quoted literals.
      if (char == "'") {
        if (i + 1 < pattern.length && pattern[i + 1] == "'") {
          buffer.write("'");
          i += 2;
          continue;
        }
        i++; // skip opening quote
        while (i < pattern.length && pattern[i] != "'") {
          buffer.write(pattern[i]);
          i++;
        }
        i++; // skip closing quote (if present)
        continue;
      }

      final token = _matchToken(i);
      if (token != null) {
        buffer.write(_expand(token, date, locale));
        i += token.length;
      } else {
        buffer.write(char);
        i++;
      }
    }
    return buffer.toString();
  }

  String? _matchToken(int index) {
    for (final token in _tokens) {
      if (pattern.startsWith(token, index)) return token;
    }
    return null;
  }

  String _expand(
    String token,
    EthiopianDate date,
    EthiopianDateLocale locale,
  ) {
    final amharic = locale == EthiopianDateLocale.amharic;
    switch (token) {
      case 'yyyy':
        return date.year.toString().padLeft(4, '0');
      case 'yy':
        return (date.year % 100).toString().padLeft(2, '0');
      case 'MMMM':
        return amharic ? date.monthInfo.amharic : date.monthInfo.english;
      case 'MM':
        return date.month.toString().padLeft(2, '0');
      case 'M':
        return date.month.toString();
      case 'dd':
        return date.day.toString().padLeft(2, '0');
      case 'd':
        return date.day.toString();
      case 'EEEE':
        return amharic ? date.weekday.amharic : date.weekday.english;
      default:
        return token;
    }
  }
}
