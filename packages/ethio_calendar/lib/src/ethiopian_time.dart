import 'ethiopian_date.dart';

/// The four parts of the day that Ethiopian time is read in.
///
/// Ethiopian clocks count twelve hours from sunrise (06:00) and twelve from
/// sunset (18:00), so the hour alone is ambiguous: "3:00" is said with the part
/// of the day, as in "ጠዋት 3:00" (09:00) or "ምሽት 3:00" (21:00).
enum EthiopianDayPart {
  /// 06:00 to 11:59 on the international clock: ጠዋት, 12:00 to 5:59.
  morning('ጠዋት', 'morning'),

  /// 12:00 to 17:59: ከሰዓት, 6:00 to 11:59.
  afternoon('ከሰዓት', 'afternoon'),

  /// 18:00 to 23:59: ምሽት, 12:00 to 5:59.
  evening('ምሽት', 'evening'),

  /// 00:00 to 05:59: ሌሊት, 6:00 to 11:59.
  night('ሌሊት', 'night');

  const EthiopianDayPart(this.amharic, this.english);

  /// Amharic (Ge'ez script) name, e.g. `ጠዋት`.
  final String amharic;

  /// English name, e.g. `morning`.
  final String english;

  /// The part of the day an international (24-hour) [hour] falls in.
  static EthiopianDayPart ofHour(int hour) {
    if (hour < 0 || hour > 23) {
      throw ArgumentError.value(hour, 'hour', 'must be in 0..23');
    }
    if (hour < 6) return night;
    if (hour < 12) return morning;
    if (hour < 18) return afternoon;
    return evening;
  }
}

/// A time of day on the Ethiopian clock, which counts the hours from 06:00.
///
/// 07:00 international is 1:00 in the morning, 12:00 is 6:00 in the
/// afternoon, 18:30 is 12:30 in the evening and 00:00 is 6:00 at night.
///
/// ```dart
/// final t = EthiopianTime.fromDateTime(DateTime(2026, 7, 9, 9, 30));
/// print(t);                                            // 3:30 morning
/// print(t.format(locale: EthiopianDateLocale.amharic)); // ጠዋት 3:30
/// print(t.toHour24());                                  // 9
/// ```
class EthiopianTime implements Comparable<EthiopianTime> {
  /// Creates a time from its Ethiopian [hour] (1..12), [minute] and [part].
  ///
  /// The hour must belong to the part: morning and evening run 12, 1 .. 5;
  /// afternoon and night run 6 .. 11.
  EthiopianTime(this.hour, this.minute, this.part) {
    if (hour < 1 || hour > 12) {
      throw ArgumentError.value(hour, 'hour', 'must be in 1..12');
    }
    if (minute < 0 || minute > 59) {
      throw ArgumentError.value(minute, 'minute', 'must be in 0..59');
    }
    final early = hour == 12 || hour <= 5;
    final firstHalf =
        part == EthiopianDayPart.morning || part == EthiopianDayPart.evening;
    if (early != firstHalf) {
      throw ArgumentError.value(
          hour, 'hour', 'is not on the clock in the ${part.english}');
    }
  }

  /// The Ethiopian time of an international [hour] (0..23) and [minute].
  factory EthiopianTime.fromHourMinute(int hour, int minute) {
    final part = EthiopianDayPart.ofHour(hour);
    final h = (hour + 6) % 12;
    return EthiopianTime(h == 0 ? 12 : h, minute, part);
  }

  /// The Ethiopian time of [dateTime], read from its own hour and minute.
  ///
  /// Convert to the wall clock you mean first, for example Addis Ababa time:
  /// `dateTime.toUtc().add(const Duration(hours: 3))`.
  factory EthiopianTime.fromDateTime(DateTime dateTime) =>
      EthiopianTime.fromHourMinute(dateTime.hour, dateTime.minute);

  /// The hour on the Ethiopian clock, 1..12.
  final int hour;

  /// The minute, 0..59.
  final int minute;

  /// The part of the day, which tells 3:00 in the morning from 3:00 at night.
  final EthiopianDayPart part;

  /// The international (24-hour) hour, 0..23.
  int toHour24() {
    final shift =
        part == EthiopianDayPart.morning || part == EthiopianDayPart.afternoon
            ? 6
            : 18;
    return (hour % 12 + shift) % 24;
  }

  /// "3:30", without the part of the day.
  String get hourMinute => '$hour:${minute.toString().padLeft(2, '0')}';

  /// "3:30 morning" in English, "ጠዋት 3:30" in Amharic, where the part of the
  /// day is said first. With [withPart] false, only the hour and minute.
  String format({
    EthiopianDateLocale locale = EthiopianDateLocale.english,
    bool withPart = true,
  }) {
    if (!withPart) return hourMinute;
    return locale == EthiopianDateLocale.amharic
        ? '${part.amharic} $hourMinute'
        : '$hourMinute ${part.english}';
  }

  /// Minutes since midnight on the international clock, for ordering.
  int get _minuteOfDay => toHour24() * 60 + minute;

  @override
  int compareTo(EthiopianTime other) => _minuteOfDay - other._minuteOfDay;

  @override
  bool operator ==(Object other) =>
      other is EthiopianTime &&
      other.hour == hour &&
      other.minute == minute &&
      other.part == part;

  @override
  int get hashCode => Object.hash(hour, minute, part);

  @override
  String toString() => format();
}
