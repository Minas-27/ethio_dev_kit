/// How the source table marks a value, or how this package derived it.
enum ValueFlag {
  /// Shown in brackets in the source: less reliable.
  lowConfidence,

  /// "tr" in the source: present in trace amounts. Stored as 0.
  trace,

  /// "<LOD" in the source: below the lab's detection limit. Stored as 0.
  belowDetection,

  /// The source gives kJ only; kcal was computed as kJ ÷ 4.184.
  computed,

  /// The printed kcal was a clear typo and was recomputed from kJ
  /// (protein, fat and carbohydrate agree with the kJ value).
  corrected,

  /// The energy value had a missing or extra bracket in the source;
  /// the numbers themselves are as printed.
  sourceTypo,
}

/// Whether a food suits Ethiopian Orthodox fasting (no meat, poultry, dairy,
/// butter or eggs), judged from the ingredients in its name.
enum FastingStatus {
  /// No animal products.
  yes,

  /// Contains meat, poultry, dairy, butter or eggs.
  no,

  /// The only animal product is fish.
  fish,

  /// Cannot be told from the name (for example honey drinks).
  unsure,
}
