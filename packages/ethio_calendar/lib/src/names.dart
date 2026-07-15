/// Amharic and English names for Ethiopian months and days of the week.
library;

/// The thirteen Ethiopian months, in order (index 0 == Meskerem, month 1).
class EthiopianMonth {
  const EthiopianMonth._(this.number, this.amharic, this.english);

  /// Month number, 1 (Meskerem) through 13 (Pagume).
  final int number;

  /// Amharic (Ge'ez script) name, e.g. `መስከረም`.
  final String amharic;

  /// Latin transliteration, e.g. `Meskerem`.
  final String english;

  @override
  String toString() => english;

  /// All thirteen months in calendar order.
  static const List<EthiopianMonth> values = <EthiopianMonth>[
    EthiopianMonth._(1, 'መስከረም', 'Meskerem'),
    EthiopianMonth._(2, 'ጥቅምት', 'Tikimt'),
    EthiopianMonth._(3, 'ኅዳር', 'Hidar'),
    EthiopianMonth._(4, 'ታኅሣሥ', 'Tahsas'),
    EthiopianMonth._(5, 'ጥር', 'Tir'),
    EthiopianMonth._(6, 'የካቲት', 'Yekatit'),
    EthiopianMonth._(7, 'መጋቢት', 'Megabit'),
    EthiopianMonth._(8, 'ሚያዝያ', 'Miazia'),
    EthiopianMonth._(9, 'ግንቦት', 'Ginbot'),
    EthiopianMonth._(10, 'ሰኔ', 'Sene'),
    EthiopianMonth._(11, 'ሐምሌ', 'Hamle'),
    EthiopianMonth._(12, 'ነሐሴ', 'Nehase'),
    EthiopianMonth._(13, 'ጳጉሜ', 'Pagume'),
  ];

  /// Returns the month with the given 1-based [number] (1..13).
  static EthiopianMonth fromNumber(int number) {
    if (number < 1 || number > 13) {
      throw ArgumentError.value(number, 'number', 'must be in 1..13');
    }
    return values[number - 1];
  }
}

/// A day of the week with Amharic and English names.
///
/// [number] follows Dart's [DateTime] convention: Monday == 1 ... Sunday == 7.
class EthiopianWeekday {
  const EthiopianWeekday._(this.number, this.amharic, this.english);

  /// ISO weekday number, Monday == 1 through Sunday == 7.
  final int number;

  /// Amharic (Ge'ez script) name, e.g. `ሰኞ`.
  final String amharic;

  /// English name, e.g. `Monday`.
  final String english;

  @override
  String toString() => english;

  /// The seven weekdays, indexed so that `values[0]` is Monday.
  static const List<EthiopianWeekday> values = <EthiopianWeekday>[
    EthiopianWeekday._(1, 'ሰኞ', 'Monday'),
    EthiopianWeekday._(2, 'ማክሰኞ', 'Tuesday'),
    EthiopianWeekday._(3, 'ረቡዕ', 'Wednesday'),
    EthiopianWeekday._(4, 'ሐሙስ', 'Thursday'),
    EthiopianWeekday._(5, 'ዓርብ', 'Friday'),
    EthiopianWeekday._(6, 'ቅዳሜ', 'Saturday'),
    EthiopianWeekday._(7, 'እሁድ', 'Sunday'),
  ];

  /// Returns the weekday for an ISO [number] (Monday == 1 ... Sunday == 7).
  static EthiopianWeekday fromNumber(int number) {
    if (number < 1 || number > 7) {
      throw ArgumentError.value(number, 'number', 'must be in 1..7');
    }
    return values[number - 1];
  }
}
