import 'package:ethio_calendar/ethio_calendar.dart';
import 'package:test/test.dart';

void main() {
  group('Gregorian <-> Ethiopian conversion (known reference dates)', () {
    // Each tuple: Gregorian (y,m,d) <-> Ethiopian (y,m,d).
    const references = <List<List<int>>>[
      // Ethiopian Millennium: Meskerem 1, 2000 EC. 2008 is a Greg leap year,
      // so New Year falls on Sept 12.
      [
        [2007, 9, 12],
        [2000, 1, 1],
      ],
      // 2016 EC New Year: 2024 is a Greg leap year -> Sept 12.
      [
        [2023, 9, 12],
        [2016, 1, 1],
      ],
      // 2013 EC New Year: 2021 not leap -> Sept 11.
      [
        [2020, 9, 11],
        [2013, 1, 1],
      ],
      // 2017 EC New Year: 2025 not leap -> Sept 11.
      [
        [2024, 9, 11],
        [2017, 1, 1],
      ],
      // Pagume 6 in the leap year 2011 EC.
      [
        [2019, 9, 11],
        [2011, 13, 6],
      ],
      // Day after: Meskerem 1, 2012 EC.
      [
        [2019, 9, 12],
        [2012, 1, 1],
      ],
      // A mid-year date: today's build date.
      [
        [2026, 7, 9],
        [2018, 11, 2],
      ],
    ];

    test('Gregorian -> Ethiopian matches references', () {
      for (final ref in references) {
        final g = ref[0];
        final e = ref[1];
        final eth = EthiopianDate.fromGregorian(DateTime(g[0], g[1], g[2]));
        expect(
          [eth.year, eth.month, eth.day],
          e,
          reason: 'Gregorian ${g.join("-")} should be Ethiopian ${e.join("-")}',
        );
      }
    });

    test('Ethiopian -> Gregorian matches references', () {
      for (final ref in references) {
        final g = ref[0];
        final e = ref[1];
        final greg = EthiopianDate(e[0], e[1], e[2]).toGregorian();
        expect(
          [greg.year, greg.month, greg.day],
          g,
          reason: 'Ethiopian ${e.join("-")} should be Gregorian ${g.join("-")}',
        );
      }
    });
  });

  group('Round-trip stability', () {
    test('every day over 1900-2100 round-trips exactly', () {
      var date = DateTime(1900, 1, 1);
      final end = DateTime(2100, 12, 31);
      var count = 0;
      while (!date.isAfter(end)) {
        final eth = EthiopianDate.fromGregorian(date);
        final back = eth.toGregorian();
        expect(
          [back.year, back.month, back.day],
          [date.year, date.month, date.day],
          reason: 'round-trip failed for $date',
        );
        // Month/day must always be in valid ranges.
        expect(eth.month, inInclusiveRange(1, 13));
        expect(eth.day, inInclusiveRange(1, 30));
        date = date.add(const Duration(days: 1));
        count++;
      }
      expect(count, greaterThan(73000));
    });
  });

  group('Leap year rules', () {
    test('leap years are those where year % 4 == 3', () {
      expect(isEthiopianLeapYear(2011), isTrue);
      expect(isEthiopianLeapYear(2015), isTrue);
      expect(isEthiopianLeapYear(2007), isTrue);
      expect(isEthiopianLeapYear(2012), isFalse);
      expect(isEthiopianLeapYear(2018), isFalse);
    });

    test('Pagume has 6 days in a leap year, 5 otherwise', () {
      expect(ethiopianDaysInMonth(2011, 13), 6);
      expect(ethiopianDaysInMonth(2012, 13), 5);
      expect(ethiopianDaysInMonth(2015, 13), 6);
    });

    test('Pagume 6 is valid in a leap year and rejected otherwise', () {
      expect(() => EthiopianDate(2011, 13, 6), returnsNormally);
      expect(() => EthiopianDate(2012, 13, 6), throwsArgumentError);
    });

    test('regular months always have 30 days', () {
      for (var m = 1; m <= 12; m++) {
        expect(ethiopianDaysInMonth(2018, m), 30);
      }
    });
  });

  group('New Year boundary edge cases', () {
    test('New Year is Sept 12 when following Gregorian year is leap', () {
      // 2016 EC -> 2023-09-12 (2024 leap).
      final ny = EthiopianDate(2016, 1, 1).toGregorian();
      expect([ny.month, ny.day], [9, 12]);
    });

    test('New Year is Sept 11 in ordinary years', () {
      final ny = EthiopianDate(2013, 1, 1).toGregorian();
      expect([ny.month, ny.day], [9, 11]);
    });

    test('day before New Year is Pagume of the previous year', () {
      final lastDay = EthiopianDate(2016, 1, 1).addDays(-1);
      expect(lastDay.month, 13);
      expect(lastDay.year, 2015);
    });
  });

  group('Validation', () {
    test('rejects out-of-range month', () {
      expect(() => EthiopianDate(2016, 0, 1), throwsArgumentError);
      expect(() => EthiopianDate(2016, 14, 1), throwsArgumentError);
    });

    test('rejects out-of-range day', () {
      expect(() => EthiopianDate(2016, 1, 0), throwsArgumentError);
      expect(() => EthiopianDate(2016, 1, 31), throwsArgumentError);
    });
  });

  group('Arithmetic and comparison', () {
    final a = EthiopianDate(2016, 1, 1);
    final b = EthiopianDate(2016, 1, 11);

    test('difference counts days signed', () {
      expect(b.difference(a), 10);
      expect(a.difference(b), -10);
      expect(a.difference(a), 0);
    });

    test('addDays crosses month and year boundaries', () {
      // Meskerem 25 + 10 days = Tikimt 5.
      final crossed = EthiopianDate(2016, 1, 25).addDays(10);
      expect([crossed.month, crossed.day], [2, 5]);

      // Pagume rollover into next year. 2015 is a leap year, so its last day
      // is Pagume 6; the next day is Meskerem 1, 2016.
      final ny = EthiopianDate(2015, 13, 6).addDays(1);
      expect([ny.year, ny.month, ny.day], [2016, 1, 1]);
      // And from a non-leap year (2014), the last day is Pagume 5.
      final ny2 = EthiopianDate(2014, 13, 5).addDays(1);
      expect([ny2.year, ny2.month, ny2.day], [2015, 1, 1]);
    });

    test('comparison operators', () {
      expect(a < b, isTrue);
      expect(b > a, isTrue);
      expect(a <= EthiopianDate(2016, 1, 1), isTrue);
      expect(a >= EthiopianDate(2016, 1, 1), isTrue);
      expect(a == EthiopianDate(2016, 1, 1), isTrue);
      expect(a.compareTo(b), lessThan(0));
    });

    test('equality and hashCode are value-based', () {
      expect(a, EthiopianDate(2016, 1, 1));
      expect(a.hashCode, EthiopianDate(2016, 1, 1).hashCode);
      expect(a == b, isFalse);
    });

    test('dayOfYear', () {
      expect(EthiopianDate(2016, 1, 1).dayOfYear, 1);
      expect(EthiopianDate(2016, 2, 1).dayOfYear, 31);
      expect(EthiopianDate(2016, 13, 5).dayOfYear, 365);
    });
  });

  group('Weekday', () {
    test('weekday matches the Gregorian equivalent', () {
      // 2026-07-09 is a Thursday.
      final eth = EthiopianDate.fromGregorian(DateTime(2026, 7, 9));
      expect(eth.weekday.english, 'Thursday');
      expect(eth.weekday.amharic, 'ሐሙስ');
      expect(eth.weekday.number, DateTime.thursday);
    });
  });

  group('Names', () {
    test('all 13 months resolve with both scripts', () {
      expect(EthiopianMonth.values.length, 13);
      expect(EthiopianMonth.fromNumber(1).english, 'Meskerem');
      expect(EthiopianMonth.fromNumber(1).amharic, 'መስከረም');
      expect(EthiopianMonth.fromNumber(13).english, 'Pagume');
      expect(EthiopianMonth.fromNumber(13).amharic, 'ጳጉሜ');
    });

    test('fromNumber validates range', () {
      expect(() => EthiopianMonth.fromNumber(0), throwsArgumentError);
      expect(() => EthiopianMonth.fromNumber(14), throwsArgumentError);
      expect(() => EthiopianWeekday.fromNumber(8), throwsArgumentError);
    });
  });

  group('Formatting', () {
    final date = EthiopianDate(2018, 11, 2); // Hamle 2, 2018 (a Thursday)

    test('numeric patterns', () {
      expect(date.format('dd/MM/yyyy'), '02/11/2018');
      expect(date.format('d/M/yy'), '2/11/18');
      expect(date.format('yyyy-MM-dd'), '2018-11-02');
    });

    test('English month/weekday names', () {
      expect(date.format('MMMM d, yyyy'), 'Hamle 2, 2018');
      expect(date.format('EEEE'), 'Thursday');
    });

    test('Amharic month/weekday names', () {
      expect(
        date.format('MMMM d, yyyy', locale: EthiopianDateLocale.amharic),
        'ሐምሌ 2, 2018',
      );
      expect(
        date.format('EEEE', locale: EthiopianDateLocale.amharic),
        'ሐሙስ',
      );
    });

    test('quoted literals and passthrough characters', () {
      expect(date.format("'Today is' MMMM d"), 'Today is Hamle 2');
      expect(date.format("d''M"), "2'11");
    });
  });

  group('toString', () {
    test('is zero-padded ISO-like', () {
      expect(EthiopianDate(2018, 11, 2).toString(), '2018-11-02');
      expect(EthiopianDate(500, 1, 1).toString(), '0500-01-01');
    });
  });
}
