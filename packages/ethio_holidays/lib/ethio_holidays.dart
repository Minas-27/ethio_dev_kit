import 'package:ethio_calendar/ethio_calendar.dart';
import 'src/computus.dart';

export 'src/computus.dart'
    show calculateOrthodoxEaster, tabularHijriToGregorian;

/// Category of an Ethiopian holiday.
enum EthioHolidayCategory {
  /// Fixed date in the Ethiopian or Gregorian calendar (e.g. Enkutatash, Labour Day).
  fixed,

  /// Moveable feast tied to the Orthodox (Julian) Easter computus (e.g. Fasika).
  orthodoxMoveable,

  /// Moveable Islamic holiday based on the lunar calendar (e.g. Eid al-Fitr).
  islamicEstimated,
}

/// Represents an Ethiopian holiday for a specific year.
class EthioHoliday {
  /// English name of the holiday.
  final String name;

  /// Amharic name of the holiday.
  final String nameAmharic;

  /// The exact or estimated Gregorian date of the holiday.
  final DateTime date;

  /// The category of the holiday.
  final EthioHolidayCategory category;

  /// True if the date is an astronomical/tabular estimate (always true for Islamic holidays).
  final bool isEstimated;

  /// Short description of the holiday.
  final String description;

  const EthioHoliday({
    required this.name,
    required this.nameAmharic,
    required this.date,
    required this.category,
    this.isEstimated = false,
    required this.description,
  });
}

/// Returns a chronological list of Ethiopian public and religious holidays
/// for the given [gregorianYear].
///
/// Optionally filter by [category].
List<EthioHoliday> holidaysForYear(int gregorianYear,
    {EthioHolidayCategory? category}) {
  final holidays = <EthioHoliday>[];

  // 1. FIXED HOLIDAYS
  if (category == null || category == EthioHolidayCategory.fixed) {
    // Labour Day is fixed to Gregorian May 1st
    holidays.add(EthioHoliday(
      name: "International Labour Day",
      nameAmharic: "የዓለም የሠራተኞች ቀን",
      date: DateTime(gregorianYear, 5, 1),
      category: EthioHolidayCategory.fixed,
      description: "International Workers' Day.",
    ));

    // For fixed Ethiopian holidays, the Gregorian year spans two Ethiopian years.
    // e.g. 2026 spans Ethiopian 2018 (until Sept 10) and 2019 (from Sept 11).
    final ethYear1 = gregorianYear - 8;
    final ethYear2 = gregorianYear - 7;
    final ethYears = [ethYear1, ethYear2];

    for (final ethYear in ethYears) {
      void addFixedEthioHoliday(int month, int day, String name,
          String nameAmharic, String description) {
        final gregDate = EthiopianDate(ethYear, month, day).toGregorian();
        if (gregDate.year == gregorianYear) {
          holidays.add(EthioHoliday(
            name: name,
            nameAmharic: nameAmharic,
            date: gregDate,
            category: EthioHolidayCategory.fixed,
            description: description,
          ));
        }
      }

      addFixedEthioHoliday(1, 1, "Enkutatash", "እንቁጣጣሽ", "Ethiopian New Year.");
      addFixedEthioHoliday(
          1, 17, "Meskel", "መስቀል", "Finding of the True Cross.");
      addFixedEthioHoliday(4, 29, "Genna", "ገና", "Ethiopian Christmas.");
      addFixedEthioHoliday(5, 11, "Timkat", "ጥምቀት", "Ethiopian Epiphany.");
      addFixedEthioHoliday(6, 23, "Adwa Victory Day", "የዓድዋ ድል መታሰቢያ",
          "Commemoration of the Victory of Adwa.");
      addFixedEthioHoliday(8, 27, "Patriots' Victory Day", "የአርበኞች ቀን",
          "Ethiopian Patriots' Victory Day.");
      addFixedEthioHoliday(9, 20, "Downfall of the Derg", "ደርግ የወደቀበት ቀን",
          "Commemoration of the Downfall of the Derg.");
    }
  }

  // 2. ORTHODOX MOVEABLE FEASTS
  if (category == null || category == EthioHolidayCategory.orthodoxMoveable) {
    final fasikaDate = calculateOrthodoxEaster(gregorianYear);

    // Start of Great Lent (Abiy Tsom) is 55 days before Easter
    holidays.add(EthioHoliday(
      name: "Start of Great Lent",
      nameAmharic: "ዐቢይ ጾም",
      date: fasikaDate.subtract(const Duration(days: 55)),
      category: EthioHolidayCategory.orthodoxMoveable,
      description: "Start of the Great Lent (Abiy Tsom).",
    ));

    // Good Friday (Siklet) is 2 days before Easter
    holidays.add(EthioHoliday(
      name: "Siklet",
      nameAmharic: "ስቅለት",
      date: fasikaDate.subtract(const Duration(days: 2)),
      category: EthioHolidayCategory.orthodoxMoveable,
      description: "Ethiopian Good Friday.",
    ));

    holidays.add(EthioHoliday(
      name: "Fasika",
      nameAmharic: "ፋሲካ",
      date: fasikaDate,
      category: EthioHolidayCategory.orthodoxMoveable,
      description: "Ethiopian Orthodox Easter.",
    ));
  }

  // 3. ISLAMIC ESTIMATES
  if (category == null || category == EthioHolidayCategory.islamicEstimated) {
    // Estimate corresponding Hijri year base.
    // Hijri year = (Gregorian - 622) * (33 / 32)
    final approxHijriYear = ((gregorianYear - 622) * 33) ~/ 32;

    // Check a small window of Hijri years to find holidays falling in this Gregorian year
    for (int hYear = approxHijriYear - 1;
        hYear <= approxHijriYear + 1;
        hYear++) {
      void addIslamicHoliday(int month, int day, String name,
          String nameAmharic, String description) {
        final gregDate = tabularHijriToGregorian(hYear, month, day);
        if (gregDate.year == gregorianYear) {
          holidays.add(EthioHoliday(
            name: name,
            nameAmharic: nameAmharic,
            date: gregDate,
            category: EthioHolidayCategory.islamicEstimated,
            isEstimated: true,
            description: description,
          ));
        }
      }

      addIslamicHoliday(
          10, 1, "Eid al-Fitr", "ዒድ አል-ፊጥር", "End of Ramadan (Estimated).");
      addIslamicHoliday(12, 10, "Eid al-Adha", "ዒድ አል-አድሃ",
          "Feast of the Sacrifice (Estimated).");
      addIslamicHoliday(3, 12, "Mawlid al-Nabi", "መውሊድ",
          "The Prophet's Birthday (Estimated).");
    }
  }

  // Sort chronologically
  holidays.sort((a, b) => a.date.compareTo(b.date));

  return holidays;
}
