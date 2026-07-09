/// Low-level, well-tested conversions between the proleptic Gregorian calendar
/// and the Ethiopian (Amete Mihret) calendar, bridged through the Julian Day
/// Number (JDN).
///
/// The Ethiopian calendar has 12 months of 30 days plus a 13th month (Pagume)
/// of 5 days, or 6 days in a leap year. A year `y` is a leap year when
/// `y % 4 == 3`, which places the extra Pagume day in the year immediately
/// before a Gregorian leap year.
library;

/// Julian Day Number of Meskerem 1, year 1 in the Ethiopian (Amete Mihret)
/// calendar. Verified so that Meskerem 1, 2000 EC maps to 12 September 2007.
const int _ethiopicEpoch = 1724221;

/// Converts a proleptic Gregorian date to its Julian Day Number.
int gregorianToJdn(int year, int month, int day) {
  final a = (14 - month) ~/ 12;
  final y = year + 4800 - a;
  final m = month + 12 * a - 3;
  return day +
      (153 * m + 2) ~/ 5 +
      365 * y +
      y ~/ 4 -
      y ~/ 100 +
      y ~/ 400 -
      32045;
}

/// Converts a Julian Day Number to a proleptic Gregorian date `[year, month, day]`.
List<int> jdnToGregorian(int jdn) {
  final a = jdn + 32044;
  final b = (4 * a + 3) ~/ 146097;
  final c = a - (146097 * b) ~/ 4;
  final d = (4 * c + 3) ~/ 1461;
  final e = c - (1461 * d) ~/ 4;
  final m = (5 * e + 2) ~/ 153;
  final day = e - (153 * m + 2) ~/ 5 + 1;
  final month = m + 3 - 12 * (m ~/ 10);
  final year = 100 * b + d - 4800 + (m ~/ 10);
  return <int>[year, month, day];
}

/// Converts an Ethiopian date to its Julian Day Number.
int ethiopianToJdn(int year, int month, int day) {
  return (_ethiopicEpoch - 1) +
      365 * (year - 1) +
      (year ~/ 4) +
      30 * (month - 1) +
      day;
}

/// Converts a Julian Day Number to an Ethiopian date `[year, month, day]`.
List<int> jdnToEthiopian(int jdn) {
  final year = (4 * (jdn - _ethiopicEpoch) + 1463) ~/ 1461;
  final month = (jdn - ethiopianToJdn(year, 1, 1)) ~/ 30 + 1;
  final day = jdn - ethiopianToJdn(year, month, 1) + 1;
  return <int>[year, month, day];
}

/// Whether [year] is an Ethiopian leap year (Pagume has 6 days).
bool isEthiopianLeapYear(int year) => year % 4 == 3;

/// Number of days in [month] of Ethiopian [year] (1..13).
int ethiopianDaysInMonth(int year, int month) {
  if (month < 1 || month > 13) {
    throw ArgumentError.value(month, 'month', 'must be in 1..13');
  }
  if (month == 13) return isEthiopianLeapYear(year) ? 6 : 5;
  return 30;
}
