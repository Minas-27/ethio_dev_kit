# Changelog

## 0.1.0

Initial release.

- `EthiopianDate` with Gregorian ⇄ Ethiopian conversion via Julian Day Number.
- Correct Ethiopian leap-year handling (Pagume has 5 or 6 days).
- Correct New Year (Meskerem 1) boundary — Sept 11 or Sept 12 depending on the
  following Gregorian year.
- Amharic and English names for all 13 months and 7 weekdays.
- Pattern-based `format()` supporting `yyyy`, `yy`, `MMMM`, `MM`, `M`, `dd`,
  `d`, `EEEE`, quoted literals, in English and Amharic locales.
- Date arithmetic (`addDays`, `difference`), comparison operators, and
  value equality.
- Pure Dart, zero runtime dependencies.
- Dart CLI example and a Flutter date-picker example app.
