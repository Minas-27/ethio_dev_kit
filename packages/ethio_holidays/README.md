# ethio_holidays

[![pub package](https://img.shields.io/pub/v/ethio_holidays.svg)](https://pub.dev/packages/ethio_holidays)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

Computes Ethiopian public and religious holidays for any given Gregorian year dynamically.

This package provides accurate calculations for fixed Ethiopian holidays, Orthodox moveable feasts (using Meeus' Julian algorithm), and astronomical estimates for Islamic holidays using the standard civil tabular Hijri calendar.

## Installation

Add it to your `pubspec.yaml`:

```yaml
dependencies:
  ethio_holidays: ^0.1.0
```

## Disclaimer: Islamic Holiday Estimates

> [!WARNING]  
> **Islamic holidays (Eid al-Fitr, Eid al-Adha, and Mawlid al-Nabi) returned by this package are astronomical estimates.**
> 
> They are calculated using the standard civil 30-year tabular Hijri calendar, which is mathematically predictable and accurate to roughly **±1 day**. However, actual religious observance dates in Ethiopia (and globally) depend on official moon-sighting announcements by religious authorities. 
> 
> Do not present these tabular estimates to users as authoritative dates without a disclaimer. These holidays are marked with `isEstimated: true` in the API.

## Public API

The primary entry point is `holidaysForYear`, but the underlying calendar computus utilities are also exposed for standalone use.

| Function | Description |
| :--- | :--- |
| `holidaysForYear(int gregorianYear, {EthioHolidayCategory? category})` | Returns a list of `EthioHoliday` objects for the given Gregorian year. Optionally filter by category (fixed, orthodoxMoveable, islamicEstimated). |
| `calculateOrthodoxEaster(int gregorianYear)` | Returns a `DateTime` representing the Gregorian date of Ethiopian Orthodox Easter (Fasika) using Meeus' Julian Easter algorithm. |
| `tabularHijriToGregorian(int year, int month, int day)` | Converts a Hijri date to a Gregorian `DateTime` using the civil tabular Islamic calendar algorithm. |

## Usage

```dart
import 'package:ethio_holidays/ethio_holidays.dart';

void main() {
  final holidays = holidaysForYear(2026);
  
  for (final holiday in holidays) {
    final status = holiday.isEstimated ? "(Estimated)" : "(Fixed)";
    print('${holiday.date.toString().substring(0, 10)} : ${holiday.name} $status');
  }
}
```
