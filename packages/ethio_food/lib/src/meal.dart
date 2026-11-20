import 'food.dart';
import 'nutrient.dart';

/// Several portions eaten together, for example enjera with shiro.
class Meal {
  /// A meal made of [portions].
  const Meal(this.portions);

  /// The portions in the meal.
  final List<Portion> portions;

  /// Total weight in grams.
  double get grams => portions.fold(0, (sum, p) => sum + p.grams);

  /// Total of [nutrient] across all portions. Portions without a value for
  /// [nutrient] count as 0; check [isComplete] when that matters.
  double total(Nutrient nutrient) =>
      portions.fold(0, (sum, p) => sum + (p[nutrient] ?? 0));

  /// Whether every portion has a value for [nutrient].
  bool isComplete(Nutrient nutrient) =>
      portions.every((p) => p[nutrient] != null);

  /// Share of the adult Daily Value of [nutrient], as a percentage, or `null`
  /// when [nutrient] has no Daily Value.
  double? percentDailyValue(Nutrient nutrient) {
    final dv = nutrient.dailyValue;
    return dv == null ? null : total(nutrient) / dv * 100;
  }
}
