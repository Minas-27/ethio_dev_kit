import 'food_group.dart';
import 'nutrient.dart';
import 'value_flag.dart';

/// One food from the Ethiopian Food Composition Table 2025.
///
/// Nutrient values are per 100 g of the edible portion, as in the source.
/// Use [per] to scale them to a portion.
class Food {
  /// Used by the generated data table. Not part of the public API.
  const Food.internal(
    this.code,
    this.group,
    this.name,
    this.nameFull,
    this.nameAm,
    this.nameAmFull,
    this.nameAmLatin,
    this.aliases,
    this.isCommon,
    this.fasting,
    this.ediblePortion,
    this._values,
    this._flags,
  );

  /// Six-digit food code from the source table, for example `030095`.
  final String code;

  /// Food group.
  final FoodGroup group;

  /// Short English name, for example `Shiro wot (alicha)`.
  final String name;

  /// Full English description as printed in the source table.
  final String nameFull;

  /// Short Amharic name in Ge'ez script, for example `ሽሮ ወጥ (አልጫ)`.
  final String nameAm;

  /// Full Amharic name in Ge'ez script.
  final String nameAmFull;

  /// Amharic name in Latin letters, as printed in the source table.
  final String nameAmLatin;

  /// Search words in both scripts (spelling variants included).
  final List<String> aliases;

  /// Whether this is an everyday food for most Ethiopians.
  final bool isCommon;

  /// Suitability for Ethiopian Orthodox fasting.
  final FastingStatus fasting;

  /// Edible portion as a fraction of the food as bought (1.0 = all of it).
  final double? ediblePortion;

  final List<double?> _values;
  final Map<int, List<ValueFlag>> _flags;

  /// The value of [nutrient] per 100 g, or `null` when the table has none.
  double? operator [](Nutrient nutrient) => _values[nutrient.index];

  /// The value of [nutrient] per 100 g, or `null` when the table has none.
  double? valueOf(Nutrient nutrient) => _values[nutrient.index];

  /// How the source marks the value of [nutrient], if at all.
  List<ValueFlag> flagsOf(Nutrient nutrient) =>
      _flags[nutrient.index] ?? const [];

  /// Every nutrient that has a value, with its value per 100 g.
  Map<Nutrient, double> get nutrients => {
        for (final n in Nutrient.values)
          if (_values[n.index] != null) n: _values[n.index]!,
      };

  /// This food scaled to [grams] of edible portion.
  Portion per(double grams) => Portion(this, grams);

  /// Energy in kcal per 100 g.
  double? get kcal => this[Nutrient.energyKcal];

  /// Protein in g per 100 g.
  double? get protein => this[Nutrient.protein];

  /// Iron in mg per 100 g.
  double? get iron => this[Nutrient.iron];

  @override
  String toString() => 'Food($code, $name)';
}

/// A food at a given weight. Values are scaled from the per-100 g values.
class Portion {
  /// [grams] of edible portion of [food].
  const Portion(this.food, this.grams);

  /// The food.
  final Food food;

  /// Weight of the edible portion in grams.
  final double grams;

  /// The value of [nutrient] in this portion, or `null` when the table has none.
  double? operator [](Nutrient nutrient) {
    final v = food[nutrient];
    return v == null ? null : v * grams / 100;
  }

  /// Share of the adult Daily Value of [nutrient] in this portion, as a
  /// percentage, or `null` when there is no value or no Daily Value.
  double? percentDailyValue(Nutrient nutrient) {
    final v = this[nutrient], dv = nutrient.dailyValue;
    return v == null || dv == null ? null : v / dv * 100;
  }

  @override
  String toString() => 'Portion(${food.code}, ${grams}g)';
}
