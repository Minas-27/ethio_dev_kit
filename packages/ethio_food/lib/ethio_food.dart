/// Ethiopian food composition data: 722 foods and 39 nutrients from the
/// Ethiopian Food Composition Table 2025 (EPHI and FAO), with English and
/// Amharic names, search, portions and meals. Pure Dart, no dependencies.
library;

import 'src/data.g.dart';
import 'src/food.dart';
import 'src/food_group.dart';
import 'src/nutrient.dart';
import 'src/search.dart';
import 'src/value_flag.dart';

export 'src/food.dart' show Food, Portion;
export 'src/food_group.dart';
export 'src/meal.dart';
export 'src/nutrient.dart';
export 'src/search.dart' show foldForSearch, FoodIndex;
export 'src/value_flag.dart';

/// Entry point to the table.
abstract final class EthioFood {
  /// Citation for the data. Show it wherever you use the data.
  static const String source =
      'Ethiopian Food Composition Table 2025, Ethiopian Public Health Institute (EPHI) and FAO. Not endorsed by EPHI.';

  /// Every food, ordered by food code.
  static List<Food> get all => foodTable;

  static final Map<String, Food> _byCode = {
    for (final f in foodTable) f.code: f
  };
  static FoodIndex? _index;

  /// The food with this six-digit [code], or `null`.
  static Food? byCode(String code) => _byCode[code];

  /// Foods matching [query] in English or Amharic, best first.
  /// Letters that sound alike in Amharic (ሰ/ሠ, ሀ/ሐ/ኀ, አ/ዐ, ጸ/ፀ) match each other.
  static List<Food> search(String query, {int limit = 20}) =>
      (_index ??= FoodIndex(foodTable)).search(query, limit: limit);

  /// Foods in [group].
  static List<Food> inGroup(FoodGroup group) =>
      foodTable.where((f) => f.group == group).toList();

  /// Foods that suit Ethiopian Orthodox fasting (no animal products).
  static List<Food> get fastingFriendly =>
      foodTable.where((f) => f.fasting == FastingStatus.yes).toList();

  /// Foods that have a value for [nutrient], highest per 100 g first.
  /// Pass [where] to narrow the list, for example to everyday foods.
  static List<Food> richestIn(Nutrient nutrient,
      {bool Function(Food)? where, int limit = 20}) {
    final list = foodTable
        .where((f) => f[nutrient] != null && (where == null || where(f)))
        .toList()
      ..sort((a, b) => b[nutrient]!.compareTo(a[nutrient]!));
    return list.take(limit).toList();
  }
}
