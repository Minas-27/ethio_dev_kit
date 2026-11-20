// A minimal command-line demonstration of the ethio_food package.
//
// Run with:  dart run example/ethio_food_example.dart
//
// ignore_for_file: avoid_print — printing to stdout is the point of a CLI demo.
import 'package:ethio_food/ethio_food.dart';

void main() {
  // Search in Amharic or English.
  final shiro = EthioFood.search('ሽሮ ወጥ').first;
  print('${shiro.nameAm} / ${shiro.name}');
  print('Per 100 g: ${shiro.kcal} kcal, ${shiro.protein} g protein');

  // Scale to a portion.
  final serving = shiro.per(200);
  print('200 g: ${serving[Nutrient.protein]!.toStringAsFixed(1)} g protein');

  // A whole meal: one enjera (about 150 g) with a serving of shiro.
  final enjera = EthioFood.byCode('010111')!; // Enjera, white teff
  final meal = Meal([enjera.per(150), serving]);
  print('Meal: ${meal.total(Nutrient.energyKcal).round()} kcal, '
      '${meal.percentDailyValue(Nutrient.iron)!.round()}% of daily iron');

  // Fasting-friendly foods richest in protein, everyday foods only.
  for (final f in EthioFood.richestIn(Nutrient.protein,
      where: (f) => f.fasting == FastingStatus.yes && f.isCommon, limit: 5)) {
    print('${f.name}: ${f.protein} g protein per 100 g');
  }

  print(EthioFood.source);
}
