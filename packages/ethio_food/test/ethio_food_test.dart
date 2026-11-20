import 'package:ethio_food/ethio_food.dart';
import 'package:test/test.dart';

void main() {
  group('table', () {
    test('has 722 foods with unique six-digit codes', () {
      expect(EthioFood.all, hasLength(722));
      final codes = EthioFood.all.map((f) => f.code).toSet();
      expect(codes, hasLength(722));
      expect(codes.every((c) => RegExp(r'^\d{6}$').hasMatch(c)), isTrue);
    });

    test('every food has names in both languages and a matching group', () {
      for (final f in EthioFood.all) {
        expect(f.name, isNotEmpty, reason: f.code);
        expect(f.nameAm, isNotEmpty, reason: f.code);
        expect(f.group.code, f.code.substring(0, 2), reason: f.code);
      }
    });

    test('matches the source for known foods', () {
      final shiro = EthioFood.byCode('030085')!; // Shiro wot (key)
      expect(shiro.kcal, 133);
      expect(shiro[Nutrient.energyKj], 550);
      final egg = EthioFood.byCode('080001')!; // Egg, chicken, whole, raw
      expect(egg.protein, 11.3);
      expect(egg.ediblePortion, 0.88);
    });

    test('keeps the source flags', () {
      final barley =
          EthioFood.byCode('010016')!; // fat is bracketed in the source
      expect(barley.flagsOf(Nutrient.fat), contains(ValueFlag.lowConfidence));
      final corrected = EthioFood.byCode('020021')!; // printed 544(544)
      expect(corrected.kcal, 130);
      expect(corrected.flagsOf(Nutrient.energyKcal),
          contains(ValueFlag.corrected));
    });

    test('proximates add up to about 100 g for food (not drinks)', () {
      const keys = [
        Nutrient.water,
        Nutrient.protein,
        Nutrient.fat,
        Nutrient.carbohydrate,
        Nutrient.fiber,
        Nutrient.ash
      ];
      for (final f
          in EthioFood.all.where((f) => f.group != FoodGroup.beverages)) {
        if (keys.any((k) => f[k] == null)) continue;
        final sum = keys.fold<double>(0, (s, k) => s + f[k]!);
        expect(sum, inInclusiveRange(90, 106), reason: '${f.code} ${f.name}');
      }
    });
  });

  group('search', () {
    test('finds foods in English, Amharic and Latin Amharic', () {
      expect(EthioFood.search('shiro').first.name, contains('Shiro'));
      expect(
          EthioFood.search('ምስር').first.name.toLowerCase(), contains('misir'));
      expect(EthioFood.search('kitfo').map((f) => f.code), contains('070153'));
    });

    test('treats Amharic letters that sound alike as equal', () {
      expect(foldForSearch('ሠ'), foldForSearch('ሰ'));
      expect(foldForSearch('ሐ'), foldForSearch('ሀ'));
      expect(foldForSearch('ኀ'), foldForSearch('ሀ'));
      expect(foldForSearch('ዐ'), foldForSearch('አ'));
      expect(foldForSearch('ፀ'), foldForSearch('ጸ'));
    });

    test('returns nothing for empty or unknown queries', () {
      expect(EthioFood.search('  '), isEmpty);
      expect(EthioFood.search('zzqqxx'), isEmpty);
    });
  });

  group('portions and meals', () {
    test('scales values by weight', () {
      final f = EthioFood.byCode('030085')!;
      expect(f.per(200)[Nutrient.energyKcal], closeTo(266, 1e-9));
      expect(f.per(50)[Nutrient.protein], closeTo(f.protein! / 2, 1e-9));
    });

    test('totals a meal and gives daily value percentages', () {
      final meal = Meal([
        EthioFood.byCode('010111')!.per(150),
        EthioFood.byCode('030095')!.per(200)
      ]);
      expect(meal.grams, 350);
      expect(
          meal.total(Nutrient.iron), greaterThan(18)); // more than a day's iron
      expect(meal.percentDailyValue(Nutrient.iron), greaterThan(100));
      expect(meal.percentDailyValue(Nutrient.water), isNull);
    });
  });

  group('filters', () {
    test('fasting-friendly foods contain no meat, dairy or eggs groups', () {
      final groups = EthioFood.fastingFriendly.map((f) => f.group).toSet();
      expect(groups.contains(FoodGroup.meatAndPoultry), isFalse);
      expect(groups.contains(FoodGroup.milkAndDairy), isFalse);
      expect(groups.contains(FoodGroup.eggs), isFalse);
    });

    test('richestIn sorts by value', () {
      final list = EthioFood.richestIn(Nutrient.iron, limit: 10);
      for (var i = 1; i < list.length; i++) {
        expect(list[i - 1].iron!, greaterThanOrEqualTo(list[i].iron!));
      }
    });
  });
}
