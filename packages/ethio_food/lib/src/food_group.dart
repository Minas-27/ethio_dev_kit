/// The 17 food groups of the Ethiopian Food Composition Table 2025.
enum FoodGroup {
  cereals('01', 'Cereals and their products', 'እህል'),
  rootsAndTubers('02', 'Starchy roots, tubers and their products', 'ሥራሥር'),
  legumes('03', 'Legumes and their products', 'ጥራጥሬ'),
  vegetables('04', 'Vegetables and their products', 'አትክልት'),
  fruits('05', 'Fruits and their products', 'ፍራፍሬ'),
  nutsAndSeeds('06', 'Nuts, seeds and their products', 'ለውዝና ቅባት እህል'),
  meatAndPoultry('07', 'Meat, poultry and their products', 'ሥጋና ዶሮ'),
  eggs('08', 'Eggs and their products', 'እንቁላል'),
  fish('09', 'Fish, seafood and their products', 'ዓሣ'),
  milkAndDairy('10', 'Milk and its products', 'ወተትና ተዋጽኦ'),
  fatsAndOils('11', 'Fats and oils', 'ቅቤና ዘይት'),
  beverages('12', 'Beverages', 'መጠጦች'),
  sugarAndSweets('13', 'Sugar and sweetened products', 'ስኳርና ጣፋጭ'),
  spicesAndCondiments('14', 'Condiments and spices', 'ቅመማ ቅመም'),
  miscellaneous('15', 'Miscellaneous', 'ሌሎች'),
  soupsAndSauces('16', 'Soups and sauces', 'ሾርባና መረቅ'),
  mixedDishes('17', 'Mixed dishes', 'ድብልቅ ምግቦች');

  const FoodGroup(this.code, this.nameEn, this.nameAm);

  /// The two-digit group code, the first two digits of every food code.
  final String code;

  /// The group name in English, as in the source table.
  final String nameEn;

  /// The group name in Amharic (Ge'ez script).
  final String nameAm;

  /// The group for a two-digit [code], or `null`.
  static FoodGroup? fromCode(String code) {
    for (final g in values) {
      if (g.code == code) return g;
    }
    return null;
  }
}
