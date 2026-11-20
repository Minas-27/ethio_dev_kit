# ethio_food

[![pub package](https://img.shields.io/pub/v/ethio_food.svg)](https://pub.dev/packages/ethio_food)
[![CI](https://github.com/Minas-27/ethio_dev_kit/actions/workflows/ci.yaml/badge.svg)](https://github.com/Minas-27/ethio_dev_kit/actions/workflows/ci.yaml)
[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

Ethiopian food composition data for Dart and Flutter: **722 foods** and **39
nutrients** from the official **Ethiopian Food Composition Table 2025**
(Ethiopian Public Health Institute and FAO), with English and Amharic names,
search, portions and meals.

The data is compiled into the package, so it works offline with **no
dependencies** and no network calls, in Flutter apps, on the server and in
command-line tools.

## Features

- ✅ 722 foods, including Ethiopian dishes such as shiro wot, misir wot, kitfo,
  genfo and enjera firfir, in 17 food groups.
- ✅ 39 nutrients per 100 g of edible portion: energy, protein, fat, carbs,
  fibre, 10 minerals, 15 vitamin values and 7 fatty-acid and other components.
- ✅ English and Amharic (Ge'ez) names for every food, plus the source's Amharic
  in Latin letters and search words in both scripts.
- ✅ Search in English or Amharic. Amharic letters that sound alike (ሰ/ሠ,
  ሀ/ሐ/ኀ, አ/ዐ, ጸ/ፀ) match each other.
- ✅ Portions (`food.per(200)`) and meals (`Meal([...]).total(...)`), with adult
  Daily Value percentages.
- ✅ Ethiopian Orthodox fasting status and an everyday-food flag for each food.
- ✅ The source's own quality flags on each value (less certain, trace, below
  detection), and every correction to the source marked, never silent.

## Why ethio_food

- **Official data, checked.** Values were extracted from the published table and
  compared with a second, independent extraction: 24,963 values, 0 mismatches.
  Where the source had a clear typo, the fix is flagged on the value.
- **Built for Ethiopian apps.** Names people actually search for (shiro, ሽሮ,
  misir, ምስር), fasting status, and Ethiopian dishes, not just raw ingredients.
- **Zero dependencies.** Pure Dart; nothing added to your dependency tree.
- **Part of a kit.** Works with [ethio_calendar](https://pub.dev/packages/ethio_calendar),
  [ethio_holidays](https://pub.dev/packages/ethio_holidays) and the other
  [Ethio Dev Kit](https://github.com/Minas-27/ethio_dev_kit) packages.

## Install

```yaml
dependencies:
  ethio_food: ^0.1.0
```

Then:

```sh
dart pub get
```

## Usage

```dart
import 'package:ethio_food/ethio_food.dart';

// Search in Amharic or English.
final shiro = EthioFood.search('ሽሮ ወጥ').first;
print(shiro.nameAm);            // ሽሮ ወጥ (አልጫ)
print(shiro.name);              // Shiro wot (alicha)
print(shiro.kcal);              // 150.0, per 100 g

// Any nutrient, per 100 g.
shiro[Nutrient.iron];           // mg per 100 g
Nutrient.iron.unit;             // 'mg'
Nutrient.iron.nameAm;           // 'አይረን'

// Scale to a portion.
final serving = shiro.per(200);
serving[Nutrient.protein];      // grams of protein in 200 g
serving.percentDailyValue(Nutrient.iron);

// A whole meal: one enjera with a serving of shiro.
final enjera = EthioFood.byCode('010111')!; // Enjera, white teff
final meal = Meal([enjera.per(150), serving]);
meal.total(Nutrient.energyKcal);            // 525
meal.percentDailyValue(Nutrient.iron);      // 116

// Filters.
EthioFood.inGroup(FoodGroup.legumes);
EthioFood.fastingFriendly;
EthioFood.richestIn(Nutrient.protein, where: (f) => f.isCommon, limit: 10);

// The source's quality flags.
EthioFood.byCode('010016')!.flagsOf(Nutrient.fat); // [ValueFlag.lowConfidence]
```

## API at a glance

| Member | What it gives you |
|---|---|
| `EthioFood.all` | Every food, ordered by code |
| `EthioFood.byCode(code)` | One food by its six-digit code |
| `EthioFood.search(query)` | Foods matching an English or Amharic query, best first |
| `EthioFood.inGroup(group)` | Foods in a `FoodGroup` |
| `EthioFood.fastingFriendly` | Foods with no animal products |
| `EthioFood.richestIn(nutrient)` | Foods with the most of a nutrient per 100 g |
| `food[nutrient]` | A value per 100 g, or `null` when not measured |
| `food.per(grams)` | A `Portion` with scaled values and `percentDailyValue` |
| `Meal(portions)` | Totals across portions |
| `food.flagsOf(nutrient)` | How the source marks a value |
| `Nutrient.x.unit`, `.nameEn`, `.nameAm`, `.dailyValue` | Metadata for each nutrient |

## Notes

- **Units.** Values are per 100 g of the **edible portion**, as in the source.
  `food.ediblePortion` gives the edible share of the food as bought.
- **Missing values.** `null` means the table has no value, not zero. Trace
  amounts and values below the detection limit are stored as 0 with a flag.
- **Daily Values** are US FDA adult labelling values, included to give a sense of
  scale. Children, pregnancy and medical conditions have different needs.
- **Names.** Short names, Ge'ez spellings, search words and fasting status were
  added on top of the source table. The Amharic spellings are being reviewed;
  please open an issue if you spot a mistake.
- **Not medical advice.** This is nutrition information.

## Data source and licence

Data: Ethiopian Public Health Institute (EPHI) and Food and Agriculture
Organization of the United Nations (FAO) 2025. *The Ethiopian Food Composition
Table 2025.* Addis Ababa, Ethiopia. © EPHI. Available as `EthioFood.source`.

EPHI allows the data to be copied and used, including in commercial products,
provided that EPHI is acknowledged as the source and copyright holder and that
EPHI's endorsement is not implied. **If you ship this data, credit EPHI in your
app.** This package is independent and not endorsed by EPHI.

The package code is MIT licensed (see [LICENSE](LICENSE)). The dataset and the
extraction scripts live in [Minas-27/Ethio-Food](https://github.com/Minas-27/Ethio-Food).

## See it in use

[Ethio Gebeta](https://gebeta.abroid.dev) is a free web app built on this data:
search in Amharic or English (or by voice), fasting foods, and a meal builder.

---

Part of the [ethio_dev_kit](https://github.com/Minas-27/ethio_dev_kit) monorepo.
