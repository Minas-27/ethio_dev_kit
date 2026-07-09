import 'conversion.dart';
import 'formatter.dart';
import 'names.dart';

/// Which language to use when producing textual output such as month or
/// weekday names in [EthiopianDate.format].
enum EthiopianDateLocale {
  /// English / Latin transliteration (e.g. `Meskerem`, `Monday`).
  english,

  /// Amharic in Ge'ez script (e.g. `መስከረም`, `ሰኞ`).
  amharic,
}

/// An immutable date in the Ethiopian (Amete Mihret) calendar.
///
/// Construct directly from Ethiopian year/month/day, or convert from a
/// Gregorian [DateTime] with [EthiopianDate.fromGregorian]. Convert back with
/// [toDateTime]. Instances are comparable and support day arithmetic.
///
/// ```dart
/// final today = EthiopianDate.fromGregorian(DateTime(2026, 7, 9));
/// print(today); // 2018-11-02 (Hamle 2, 2018)
/// print(today.format('MMMM d, yyyy', locale: EthiopianDateLocale.amharic));
/// ```
class EthiopianDate implements Comparable<EthiopianDate> {
  /// Creates an Ethiopian date from its components.
  ///
  /// Throws [ArgumentError] if [month] is not in 1..13 or [day] is out of range
  /// for the given month (Pagume has 5 days, or 6 in a leap year).
  EthiopianDate(this.year, this.month, this.day) {
    if (month < 1 || month > 13) {
      throw ArgumentError.value(month, 'month', 'must be in 1..13');
    }
    final maxDay = ethiopianDaysInMonth(year, month);
    if (day < 1 || day > maxDay) {
      throw ArgumentError.value(
        day,
        'day',
        'must be in 1..$maxDay for month $month of $year',
      );
    }
  }

  /// Creates an Ethiopian date from a Gregorian [DateTime].
  ///
  /// Only the calendar date (year/month/day) is used; any time-of-day
  /// component is ignored.
  factory EthiopianDate.fromGregorian(DateTime date) {
    final jdn = gregorianToJdn(date.year, date.month, date.day);
    final e = jdnToEthiopian(jdn);
    return EthiopianDate(e[0], e[1], e[2]);
  }

  /// The Ethiopian date for the current instant, in the local time zone.
  factory EthiopianDate.now() => EthiopianDate.fromGregorian(DateTime.now());

  /// The Ethiopian year (Amete Mihret).
  final int year;

  /// The month, 1 (Meskerem) through 13 (Pagume).
  final int month;

  /// The day of the month, starting at 1.
  final int day;

  /// The [EthiopianMonth] metadata (Amharic + English names) for this date.
  EthiopianMonth get monthInfo => EthiopianMonth.fromNumber(month);

  /// The [EthiopianWeekday] this date falls on.
  EthiopianWeekday get weekday =>
      EthiopianWeekday.fromNumber(toDateTime().weekday);

  /// The 1-based day of the year (Meskerem 1 == 1).
  int get dayOfYear => (month - 1) * 30 + day;

  /// Whether this date's year is an Ethiopian leap year.
  bool get isLeapYear => isEthiopianLeapYear(year);

  /// The Julian Day Number for this date.
  int get julianDayNumber => ethiopianToJdn(year, month, day);

  /// Converts this Ethiopian date to a Gregorian [DateTime] at midnight local
  /// time.
  DateTime toDateTime() {
    final g = jdnToGregorian(julianDayNumber);
    return DateTime(g[0], g[1], g[2]);
  }

  /// Alias for [toDateTime]; returns the Gregorian equivalent.
  DateTime toGregorian() => toDateTime();

  /// Returns a new date [days] after this one (negative moves backwards).
  EthiopianDate addDays(int days) {
    final e = jdnToEthiopian(julianDayNumber + days);
    return EthiopianDate(e[0], e[1], e[2]);
  }

  /// Returns the signed number of days from [other] to this date.
  ///
  /// Positive when this date is later than [other].
  int difference(EthiopianDate other) =>
      julianDayNumber - other.julianDayNumber;

  /// Formats this date using [pattern]. See [EthiopianDateFormatter] for the
  /// supported tokens (e.g. `dd/MM/yyyy`, `MMMM d, yyyy`, `EEEE`).
  String format(
    String pattern, {
    EthiopianDateLocale locale = EthiopianDateLocale.english,
  }) =>
      EthiopianDateFormatter(pattern).format(this, locale: locale);

  @override
  int compareTo(EthiopianDate other) =>
      julianDayNumber.compareTo(other.julianDayNumber);

  bool operator <(EthiopianDate other) => compareTo(other) < 0;
  bool operator <=(EthiopianDate other) => compareTo(other) <= 0;
  bool operator >(EthiopianDate other) => compareTo(other) > 0;
  bool operator >=(EthiopianDate other) => compareTo(other) >= 0;

  @override
  bool operator ==(Object other) =>
      other is EthiopianDate &&
      other.year == year &&
      other.month == month &&
      other.day == day;

  @override
  int get hashCode => Object.hash(year, month, day);

  /// ISO-like `yyyy-MM-dd` representation, e.g. `2018-11-02`.
  @override
  String toString() => '${year.toString().padLeft(4, '0')}-'
      '${month.toString().padLeft(2, '0')}-'
      '${day.toString().padLeft(2, '0')}';
}
