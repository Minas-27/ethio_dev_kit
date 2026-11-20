# ethio_calendar

[![pub package](https://img.shields.io/pub/v/ethio_calendar.svg)](https://pub.dev/packages/ethio_calendar)
[![CI](https://github.com/Minas-27/ethio_dev_kit/actions/workflows/ci.yaml/badge.svg)](https://github.com/Minas-27/ethio_dev_kit/actions/workflows/ci.yaml)
[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

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
- ✅ **Ethiopian time of day** (`EthiopianTime`): the clock that counts from
  06:00, with the part of the day (ጠዋት, ከሰዓት, ምሽት, ሌሊት) in Amharic and English.

## Why ethio_calendar

- **Zero dependencies.** Pure Dart, so it adds nothing to your app's dependency
  tree and runs in Flutter, on the server and in CLI tools.
- **Checked, not assumed.** Every day from 1900 to 2100 is converted there and
  back in the test suite, plus the dates people actually check: New Year on
  Sept 11 or 12, Pagume 6, Genna on Tahsas 28 or 29, the Millennium.
- **Dates and times.** Ethiopian time is first-class, so an appointment at 09:00
  can be shown as "ጠዋት 3:00" without hand-written hour arithmetic.
- **Part of a kit.** Works with [ethio_holidays](https://pub.dev/packages/ethio_holidays),
  [ethio_validators](https://pub.dev/packages/ethio_validators),
  [ethio_address](https://pub.dev/packages/ethio_address) and
  [ethiopic_typography](https://pub.dev/packages/ethiopic_typography) from the
  same maintainer, with the same conventions.

## Install

```yaml
dependencies:
  ethio_calendar: ^0.2.0
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

## Ethiopian time

Ethiopian clocks count twelve hours from sunrise (06:00) and twelve from sunset
(18:00), so 09:00 is 3:00 in the morning and 21:00 is 3:00 in the evening. The
part of the day is what tells them apart.

```dart
final t = EthiopianTime.fromDateTime(DateTime(2026, 7, 9, 9, 30));

print(t);                                              // 3:30 morning
print(t.format(locale: EthiopianDateLocale.amharic));  // ጠዋት 3:30
print(t.hour);                                         // 3
print(t.part.amharic);                                 // ጠዋት
print(t.toHour24());                                   // 9

// From an Ethiopian time back to the international clock.
final evening = EthiopianTime(3, 0, EthiopianDayPart.evening);
print(evening.toHour24());                             // 21
```

| International | Ethiopian | Part of the day |
|---------------|-----------|-----------------|
| 06:00 – 11:59 | 12:00 – 5:59 | ጠዋት (morning) |
| 12:00 – 17:59 | 6:00 – 11:59 | ከሰዓት (afternoon) |
| 18:00 – 23:59 | 12:00 – 5:59 | ምሽት (evening) |
| 00:00 – 05:59 | 6:00 – 11:59 | ሌሊት (night) |

`EthiopianTime` reads the hour and minute of the `DateTime` you give it, so
convert to the wall clock you mean first (for Addis Ababa,
`dateTime.toUtc().add(const Duration(hours: 3))`).

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
| `EthiopianTime.fromDateTime(DateTime)` | Ethiopian time of day of a wall-clock time. |
| `EthiopianTime.fromHourMinute(h, m)` | From an international hour (0..23) and minute. |
| `EthiopianTime(hour, minute, part)` | From an Ethiopian hour (1..12) and part of the day (validated). |
| `toHour24()` / `hourMinute` / `format({locale, withPart})` | Back to 24-hour, `3:30`, `ጠዋት 3:30`. |
| `EthiopianDayPart.ofHour(h)` | Morning, afternoon, evening or night, with Amharic names. |

## Examples

- [`example/ethio_calendar_example.dart`](example/ethio_calendar_example.dart)
  — command-line demo (`dart run example/ethio_calendar_example.dart`).
- [`example/flutter_app/`](example/flutter_app/) — a Flutter app with a date
  picker converting Gregorian → Ethiopian live.

## Accuracy notes

Conversions are anchored to the Julian Day Number and validated against known
reference dates (e.g. the Ethiopian Millennium, Meskerem 1 2000 EC = 12 Sept
2007) and a full round-trip sweep of every day from 1900 to 2100. Ethiopian
time is checked the same way: every minute of the day goes there and back. The Ethiopian
calendar follows the Amete Mihret (Year of Mercy) era used in everyday Ethiopian
civil life.

## Contributing

Part of the [ethio_dev_kit](https://github.com/Minas-27/ethio_dev_kit)
monorepo. Issues and PRs welcome — please run `dart analyze` and `dart test`
before submitting.

## License

MIT © 2026 Abraham. See [LICENSE](LICENSE).
