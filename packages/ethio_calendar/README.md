# ethio_calendar

<!-- Badges: replace Minas-27 once the repo is published, then uncomment. -->
<!--
[![pub package](https://img.shields.io/pub/v/ethio_calendar.svg)](https://pub.dev/packages/ethio_calendar)
[![CI](https://github.com/Minas-27/ethio_dev_kit/actions/workflows/ci.yaml/badge.svg)](https://github.com/Minas-27/ethio_dev_kit/actions/workflows/ci.yaml)
[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
-->

Convert between the **Gregorian** and **Ethiopian (Amete Mihret)** calendars,
with Amharic and English month/day names, pattern-based formatting, and date
arithmetic.

The core is **pure Dart with zero dependencies**, so it runs everywhere Dart
runs — Flutter apps, server-side Dart, and command-line tools.

## Features

- ✅ Accurate Gregorian ⇄ Ethiopian conversion (via Julian Day Number).
- ✅ Correct leap-year handling — Pagume (the 13th month) has 5 days, or 6 in a
  leap year (`year % 4 == 3`).
- ✅ Correct New Year boundary — Meskerem 1 falls on **Sept 11 or Sept 12**
  Gregorian, depending on whether the following Gregorian year is a leap year.
- ✅ Amharic (Ge'ez script) **and** English names for all 13 months and 7 weekdays.
- ✅ Flexible `format()` with familiar pattern tokens, in either language.
- ✅ Comparison operators, `difference()`, and `addDays()`.

## Install

```yaml
dependencies:
  ethio_calendar: ^0.1.0
```

Then:

```dart
import 'package:ethio_calendar/ethio_calendar.dart';
```

## Quick start

```dart
// Gregorian -> Ethiopian
final eth = EthiopianDate.fromGregorian(DateTime(2026, 7, 9));

print(eth);                                   // 2018-11-02
print(eth.format('MMMM d, yyyy'));            // Hamle 2, 2018
print(eth.format('MMMM d, yyyy',
    locale: EthiopianDateLocale.amharic));    // ሐምሌ 2, 2018
print(eth.weekday.english);                   // Thursday
print(eth.weekday.amharic);                   // ሐሙስ

// Ethiopian -> Gregorian
final newYear = EthiopianDate(2017, 1, 1);
print(newYear.toGregorian());                 // 2024-09-11 00:00:00.000

// Arithmetic
final deadline = eth.addDays(45);
print(deadline.difference(eth));              // 45
print(eth < deadline);                        // true
```

## Format tokens

| Token  | Meaning                        | Example (Hamle 2, 2018) |
|--------|--------------------------------|-------------------------|
| `yyyy` | Zero-padded 4-digit year       | `2018`                  |
| `yy`   | 2-digit year                   | `18`                    |
| `MMMM` | Full month name (locale-aware) | `Hamle` / `ሐምሌ`         |
| `MM`   | Zero-padded month number       | `11`                    |
| `M`    | Month number                   | `11`                    |
| `dd`   | Zero-padded day                | `02`                    |
| `d`    | Day                            | `2`                     |
| `EEEE` | Full weekday name (locale)     | `Thursday` / `ሐሙስ`      |

Wrap literal text in single quotes (`'Today is' MMMM d`), and use `''` for a
literal quote. Unrecognised characters (`/`, `-`, `,`, spaces) pass through.

## API overview

| Member | Description |
|--------|-------------|
| `EthiopianDate(year, month, day)` | Construct from Ethiopian components (validates ranges). |
| `EthiopianDate.fromGregorian(DateTime)` | Convert a Gregorian date. |
| `EthiopianDate.now()` | Today, from the local clock. |
| `toGregorian()` / `toDateTime()` | Convert back to a Gregorian `DateTime`. |
| `format(pattern, {locale})` | Format using the tokens above. |
| `addDays(int)` | Date shifted by a number of days. |
| `difference(other)` | Signed day count between two dates. |
| `compareTo`, `< <= > >=`, `==` | Ordering and value equality. |
| `weekday` | `EthiopianWeekday` (Amharic + English). |
| `monthInfo` | `EthiopianMonth` (Amharic + English). |
| `isLeapYear`, `dayOfYear`, `julianDayNumber` | Derived properties. |
| `isEthiopianLeapYear(year)` | Top-level leap-year test. |
| `ethiopianDaysInMonth(year, month)` | Days in a given month. |

## Examples

- [`example/ethio_calendar_example.dart`](example/ethio_calendar_example.dart)
  — command-line demo (`dart run example/ethio_calendar_example.dart`).
- [`example/flutter_app/`](example/flutter_app/) — a Flutter app with a date
  picker converting Gregorian → Ethiopian live.

## Accuracy notes

Conversions are anchored to the Julian Day Number and validated against known
reference dates (e.g. the Ethiopian Millennium, Meskerem 1 2000 EC = 12 Sept
2007) and a full round-trip sweep of every day from 1900 to 2100. The Ethiopian
calendar follows the Amete Mihret (Year of Mercy) era used in everyday Ethiopian
civil life.

## Contributing

Part of the [ethio_dev_kit](https://github.com/Minas-27/ethio_dev_kit)
monorepo. Issues and PRs welcome — please run `dart analyze` and `dart test`
before submitting.

## License

MIT © 2026 Abraham. See [LICENSE](LICENSE).
