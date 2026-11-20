import 'food.dart';

/// Lower-cases [text], strips Latin accents and punctuation, and folds Amharic
/// letters that sound the same (ሀ/ሐ/ኀ, ሰ/ሠ, አ/ዐ, ጸ/ፀ), so either spelling matches.
String foldForSearch(String text) {
  final out = StringBuffer();
  for (final rune in text.toLowerCase().runes) {
    var c = rune;
    if (c >= 0x1210 && c <= 0x1217) {
      c -= 0x10; // ሐ -> ሀ
    } else if (c >= 0x1280 && c <= 0x1287) {
      c -= 0x80; // ኀ -> ሀ
    } else if (c >= 0x1220 && c <= 0x1227) {
      c += 0x10; // ሠ -> ሰ
    } else if (c >= 0x12D0 && c <= 0x12D7) {
      c -= 0x30; // ዐ -> አ
    } else if (c >= 0x1340 && c <= 0x1347) {
      c -= 0x08; // ፀ -> ጸ
    }
    out.writeCharCode(_latinBase[c] ?? c);
  }
  return out
      .toString()
      .replaceAll(RegExp(r"[’'`´]"), '')
      .replaceAll(RegExp(r'[^\p{L}\p{N}]+', unicode: true), ' ')
      .trim();
}

const _latinBase = {
  0xE0: 0x61,
  0xE1: 0x61,
  0xE2: 0x61,
  0xE4: 0x61,
  0xE8: 0x65,
  0xE9: 0x65,
  0xEA: 0x65,
  0xEB: 0x65,
  0xEC: 0x69,
  0xED: 0x69,
  0xEE: 0x69,
  0xEF: 0x69,
  0xF2: 0x6F,
  0xF3: 0x6F,
  0xF4: 0x6F,
  0xF6: 0x6F,
  0xF9: 0x75,
  0xFA: 0x75,
  0xFB: 0x75,
  0xFC: 0x75
};

class _Entry {
  _Entry(this.food)
      : names = [
          food.name,
          food.nameAm,
          food.nameAmFull,
          food.nameFull,
          food.nameAmLatin
        ].where((s) => s.isNotEmpty).map(foldForSearch).toList(),
        aliases = food.aliases.map(foldForSearch).toList() {
    words = {
      for (final s in [...names, ...aliases]) ...s.split(' ')
    };
    hay = [...names, ...aliases].join(' | ');
  }

  final Food food;
  final List<String> names;
  final List<String> aliases;
  late final Set<String> words;
  late final String hay;
}

/// Ranked search over a fixed list of foods.
class FoodIndex {
  /// Builds an index over [foods].
  FoodIndex(Iterable<Food> foods)
      : _entries = foods.map(_Entry.new).toList(growable: false);

  final List<_Entry> _entries;

  /// Foods matching every word of [query], best first. Matches names and
  /// search words in English, Amharic (Ge'ez) and Amharic in Latin letters.
  List<Food> search(String query, {int limit = 20}) {
    final terms =
        foldForSearch(query).split(' ').where((t) => t.isNotEmpty).toList();
    if (terms.isEmpty) return const [];
    final scored = <(double, Food)>[];
    for (final e in _entries) {
      var score = 0.0;
      var ok = true;
      for (final term in terms) {
        final s = e.aliases.contains(term)
            ? 120
            : e.names.first.startsWith(term)
                ? 80
                : e.names.any((n) => n.startsWith(term))
                    ? 60
                    : e.words.any((w) => w.startsWith(term))
                        ? 35
                        : e.hay.contains(term)
                            ? 12
                            : 0;
        if (s == 0) {
          ok = false;
          break;
        }
        score += s;
      }
      if (!ok) continue;
      if (e.food.isCommon) score += 40;
      score -=
          (e.food.nameFull.length > 120 ? 120 : e.food.nameFull.length) / 12;
      scored.add((score, e.food));
    }
    scored.sort((a, b) => b.$1.compareTo(a.$1));
    return scored.take(limit).map((x) => x.$2).toList();
  }
}
