/// A component measured in the table. Values are per 100 g of edible portion.
enum Nutrient {
  energyKcal('kcal', 'Energy', 'ኃይል', 'ENERC_KCAL', 2000),
  energyKj('kJ', 'Energy', 'ኃይል', 'ENERC', null),
  water('g', 'Water', 'ውኃ', 'WATER', null),
  protein('g', 'Protein', 'ፕሮቲን', 'PROTCNT', 50),
  fat('g', 'Fat', 'ቅባት', 'FAT', 78),
  carbohydrate('g', 'Carbohydrate, available', 'ካርቦሃይድሬት', 'CHOAVLDF', 275),
  fiber('g', 'Fibre, total dietary', 'ፋይበር', 'FIBTG', 28),
  ash('g', 'Ash', 'አመድ', 'ASH', null),
  calcium('mg', 'Calcium', 'ካልሲየም', 'CA', 1300),
  iron('mg', 'Iron', 'አይረን', 'FE', 18),
  magnesium('mg', 'Magnesium', 'ማግኒዚየም', 'MG', 420),
  phosphorus('mg', 'Phosphorus', 'ፎስፈረስ', 'P', 1250),
  potassium('mg', 'Potassium', 'ፖታሲየም', 'K', 4700),
  sodium('mg', 'Sodium', 'ሶዲየም', 'NA', 2300),
  zinc('mg', 'Zinc', 'ዚንክ', 'ZN', 11),
  copper('mg', 'Copper', 'መዳብ', 'CU', 0.9),
  manganese('mg', 'Manganese', 'ማንጋኒዝ', 'MN', 2.3),
  selenium('mcg', 'Selenium', 'ሴሊኒየም', 'SE', 55),
  thiamin('mg', 'Thiamin (B1)', 'ታያሚን (ቢ1)', 'THIA', 1.2),
  riboflavin('mg', 'Riboflavin (B2)', 'ራይቦፍላቪን (ቢ2)', 'RIBF', 1.3),
  niacinEquivalent('mg', 'Niacin equivalent (B3)', 'ናያሲን (ቢ3)', 'NIAEQ', 16),
  niacin('mg', 'Niacin, preformed', 'ናያሲን', 'NIA', null),
  vitaminB6('mg', 'Vitamin B6', 'ቫይታሚን ቢ6', 'VITB6C', 1.7),
  folate('mcg', 'Folate', 'ፎሌት', 'FOL', 400),
  vitaminB12('mcg', 'Vitamin B12', 'ቫይታሚን ቢ12', 'VITB12', 2.4),
  vitaminC('mg', 'Vitamin C', 'ቫይታሚን ሲ', 'VITC', 90),
  betaCaroteneEquivalent(
      'mcg', 'Beta-carotene equivalent', 'ቤታ ካሮቲን', 'CARTBEQ', null),
  retinol('mcg', 'Retinol', 'ሬቲኖል', 'RETOL', null),
  vitaminARe('mcg', 'Vitamin A (RE)', 'ቫይታሚን ኤ (RE)', 'VITA', null),
  vitaminARae('mcg', 'Vitamin A (RAE)', 'ቫይታሚን ኤ', 'VITA_RAE', 900),
  vitaminD('mcg', 'Vitamin D', 'ቫይታሚን ዲ', 'VITD', 20),
  vitaminE('mg', 'Vitamin E', 'ቫይታሚን ኢ', 'VITE', 15),
  alphaTocopherol('mg', 'Alpha-tocopherol', 'አልፋ ቶኮፌሮል', 'TOCPHA', null),
  phytate('mg', 'Phytate', 'ፋይቴት', 'PHYTCPP', null),
  cholesterol('mg', 'Cholesterol', 'ኮሌስትሮል', 'CHOLE', 300),
  saturatedFat('g', 'Saturated fatty acids', 'የሳቹሬትድ ቅባት', 'FASAT', 20),
  monounsaturatedFat(
      'g', 'Monounsaturated fatty acids', 'ሞኖአንሳቹሬትድ ቅባት', 'FAMS', null),
  polyunsaturatedFat(
      'g', 'Polyunsaturated fatty acids', 'ፖሊአንሳቹሬትድ ቅባት', 'FAPU', null),
  linoleicAcid('g', 'Linoleic acid (omega-6)', 'ኦሜጋ-6', 'F18D2CN6', null),
  alphaLinolenicAcid(
      'g', 'Alpha-linolenic acid (omega-3)', 'ኦሜጋ-3', 'F18D3CN3', null);

  const Nutrient(
      this.unit, this.nameEn, this.nameAm, this.infoodsTag, this.dailyValue);

  /// Unit of the value: `kcal`, `kJ`, `g`, `mg` or `mcg`.
  final String unit;

  /// English name.
  final String nameEn;

  /// Amharic name (Ge'ez script).
  final String nameAm;

  /// INFOODS tagname used by the source table.
  final String infoodsTag;

  /// Adult reference Daily Value (US FDA labelling values), in [unit], or
  /// `null` when there is none. Use it only to give a sense of scale.
  final double? dailyValue;
}
