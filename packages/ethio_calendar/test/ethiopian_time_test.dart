import 'package:ethio_calendar/ethio_calendar.dart';
import 'package:test/test.dart';

void main() {
  group('EthiopianTime from the international clock', () {
    // (24-hour hour, Ethiopian hour, part of the day)
    const table = <(int, int, EthiopianDayPart)>[
      (0, 6, EthiopianDayPart.night),
      (5, 11, EthiopianDayPart.night),
      (6, 12, EthiopianDayPart.morning),
      (7, 1, EthiopianDayPart.morning),
      (9, 3, EthiopianDayPart.morning),
      (11, 5, EthiopianDayPart.morning),
      (12, 6, EthiopianDayPart.afternoon),
      (17, 11, EthiopianDayPart.afternoon),
      (18, 12, EthiopianDayPart.evening),
      (21, 3, EthiopianDayPart.evening),
      (23, 5, EthiopianDayPart.evening),
    ];
    for (final (h24, et, part) in table) {
      test('$h24:00 is $et:00 ${part.english}', () {
        final t = EthiopianTime.fromHourMinute(h24, 0);
        expect(t.hour, et);
        expect(t.part, part);
      });
    }
  });

  test('every minute of the day goes there and back', () {
    for (var h = 0; h < 24; h++) {
      for (var m = 0; m < 60; m++) {
        final t = EthiopianTime.fromHourMinute(h, m);
        expect(t.toHour24(), h);
        expect(t.minute, m);
        expect(EthiopianTime(t.hour, t.minute, t.part), t);
      }
    }
  });

  test('formats in English and Amharic', () {
    final t = EthiopianTime.fromDateTime(DateTime(2026, 7, 9, 9, 30));
    expect(t.format(), '3:30 morning');
    expect(t.format(locale: EthiopianDateLocale.amharic), 'ጠዋት 3:30');
    expect(t.format(withPart: false), '3:30');
    expect(t.toString(), '3:30 morning');
    expect(
        EthiopianTime.fromHourMinute(18, 5)
            .format(locale: EthiopianDateLocale.amharic),
        'ምሽት 12:05');
  });

  test('orders by the time of day, not by the Ethiopian hour', () {
    final earlyMorning = EthiopianTime.fromHourMinute(7, 0); // 1:00 morning
    final lateMorning = EthiopianTime.fromHourMinute(11, 0); // 5:00 morning
    final noon = EthiopianTime.fromHourMinute(12, 0); // 6:00 afternoon
    expect(earlyMorning.compareTo(lateMorning), lessThan(0));
    expect(lateMorning.compareTo(noon), lessThan(0));
  });

  test('refuses an hour that is not on the clock in that part of the day', () {
    expect(() => EthiopianTime(7, 0, EthiopianDayPart.morning),
        throwsArgumentError);
    expect(() => EthiopianTime(3, 0, EthiopianDayPart.afternoon),
        throwsArgumentError);
    expect(() => EthiopianTime(13, 0, EthiopianDayPart.evening),
        throwsArgumentError);
    expect(() => EthiopianTime(3, 60, EthiopianDayPart.morning),
        throwsArgumentError);
    expect(() => EthiopianDayPart.ofHour(24), throwsArgumentError);
  });
}
