import 'package:ethio_calendar/ethio_calendar.dart';

/// Calculates the Gregorian Date of Orthodox Easter (Fasika) for a given
/// [gregorianYear] using Meeus's Julian Easter algorithm.
///
/// This algorithm computes the date of Easter in the Julian Calendar.
/// It then converts it to the Gregorian calendar by adding the century-specific
/// offset.
DateTime calculateOrthodoxEaster(int gregorianYear) {
  // Meeus' Julian Easter Algorithm
  final a = gregorianYear % 4;
  final b = gregorianYear % 7;
  final c = gregorianYear % 19;
  final d = (19 * c + 15) % 30;
  final e = (2 * a + 4 * b - d + 34) % 7;
  final month = (d + e + 114) ~/ 31;
  final day = ((d + e + 114) % 31) + 1;

  // The algorithm above returns the Easter date in the Julian calendar.
  // To convert the Julian date to a Gregorian date, we must add an offset.
  // The offset is determined by the number of century leap years dropped by
  // the Gregorian calendar since the Julian calendar inception.
  //
  // NOTE: For the years 1900-2099, the offset is strictly +13 days.
  // Starting from March 1, 2100, the offset will become +14 days.
  final offset = (gregorianYear ~/ 100) - (gregorianYear ~/ 400) - 2;

  // Create the DateTime in the Gregorian calendar context but using Julian
  // month and day, then simply add the days offset to jump to the actual
  // Gregorian equivalent date.
  final julianDateAsGregorian = DateTime(gregorianYear, month, day);
  return julianDateAsGregorian.add(Duration(days: offset));
}

/// Converts a Hijri (Islamic) date to a Gregorian [DateTime] using the
/// standard civil 30-year tabular Islamic calendar algorithm.
///
/// This is a mathematical approximation (accurate to roughly ±1 day).
/// The epoch used is Friday, July 19, 622 AD (1948440 JDN).
DateTime tabularHijriToGregorian(int year, int month, int day) {
  const epochJdn = 1948440; // 1 Muharram 1 AH in Julian Day Number
  
  // Total days in completed years
  final daysInYears = (year - 1) * 354 + (11 * year + 3) ~/ 30;
  
  // Total days in completed months of the current year.
  // Odd months have 30 days, even months have 29 days.
  final daysInMonths = 29 * (month - 1) + month ~/ 2;
  
  final jdn = epochJdn + daysInYears + daysInMonths + day - 1;
  
  final g = jdnToGregorian(jdn);
  
  return DateTime(g[0], g[1], g[2]);
}
