import 'package:test/test.dart';
import 'package:ethio_holidays/ethio_holidays.dart';

void main() {
  group('Fixed Ethiopian Holidays', () {
    test('Genna is Jan 7 in standard years', () {
      final holidays = holidaysForYear(2026);
      final genna = holidays.firstWhere((h) => h.name == 'Genna');
      expect(genna.date.month, 1);
      expect(genna.date.day, 7);
      expect(genna.date.year, 2026);
    });

    test('Enkutatash is Sept 11 in standard years', () {
      final holidays = holidaysForYear(2026);
      final enkutatash = holidays.firstWhere((h) => h.name == 'Enkutatash');
      expect(enkutatash.date.month, 9);
      expect(enkutatash.date.day, 11);
    });

    test('Labour Day is fixed to May 1', () {
      final holidays = holidaysForYear(2026);
      final labour = holidays.firstWhere((h) => h.name == 'International Labour Day');
      expect(labour.date.month, 5);
      expect(labour.date.day, 1);
    });
  });

  group('Orthodox Easter (Meeus Julian)', () {
    // Verified dates for Fasika
    final knownDates = {
      2024: DateTime(2024, 5, 5),
      2025: DateTime(2025, 4, 20),
      2026: DateTime(2026, 4, 12),
      2027: DateTime(2027, 5, 2),
      2028: DateTime(2028, 4, 16),
      2029: DateTime(2029, 4, 8),
      2030: DateTime(2030, 4, 28),
    };

    knownDates.forEach((year, expectedDate) {
      test('Fasika in $year is ${expectedDate.month}/${expectedDate.day}', () {
        final fasika = calculateOrthodoxEaster(year);
        expect(fasika, expectedDate);

        // Also test the holidaysForYear integration
        final holidays = holidaysForYear(year);
        final fasikaHoliday = holidays.firstWhere((h) => h.name == 'Fasika');
        expect(fasikaHoliday.date, expectedDate);
        
        final siklet = holidays.firstWhere((h) => h.name == 'Siklet');
        expect(siklet.date, expectedDate.subtract(const Duration(days: 2)));
      });
    });
  });

  group('Islamic Holiday Estimates (Tabular Hijri)', () {
    test('Eid al-Fitr 1447 lands on roughly March 20, 2026', () {
      // 1 Shawwal 1447
      final eidDate = tabularHijriToGregorian(1447, 10, 1);
      // The tabular calendar gives exact March 20, 2026
      expect(eidDate, DateTime(2026, 3, 20));

      final holidays = holidaysForYear(2026);
      final eidHoliday = holidays.firstWhere((h) => h.name == 'Eid al-Fitr');
      expect(eidHoliday.date, DateTime(2026, 3, 20));
      expect(eidHoliday.isEstimated, isTrue);
    });
  });
}
