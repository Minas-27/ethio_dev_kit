/// Convert between the Gregorian and Ethiopian (Amete Mihret) calendars, with
/// Amharic month and day names, pattern-based formatting, and date arithmetic.
///
/// The core is pure Dart with no dependencies, so it runs anywhere Dart runs —
/// Flutter apps, server-side Dart, and CLI tools alike.
///
/// ```dart
/// import 'package:ethiopian_calendar/ethiopian_calendar.dart';
///
/// final eth = EthiopianDate.fromGregorian(DateTime(2026, 7, 9));
/// print(eth.format('MMMM d, yyyy')); // Hamle 2, 2018
/// print(eth.toGregorian());          // 2026-07-09 00:00:00.000
/// ```
library;

export 'src/conversion.dart'
    show
        isEthiopianLeapYear,
        ethiopianDaysInMonth,
        gregorianToJdn,
        jdnToGregorian,
        ethiopianToJdn,
        jdnToEthiopian;
export 'src/ethiopian_date.dart';
export 'src/formatter.dart';
export 'src/names.dart';
