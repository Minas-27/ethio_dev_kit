# Changelog

## 0.2.0

- New `EthiopianTime`: the Ethiopian clock, which counts the hours from 06:00,
  with `EthiopianDayPart` (ጠዋት morning, ከሰዓት afternoon, ምሽት evening,
  ሌሊት night). Convert from a `DateTime` or a 24-hour hour and minute, back
  with `toHour24()`, and format in English (`3:30 morning`) or Amharic
  (`ጠዋት 3:30`). Ordered by the time of day; invalid hours are refused.
- Tests cover every minute of the day there and back.
- README: an Ethiopian time section, why to choose the package, and badges.

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
