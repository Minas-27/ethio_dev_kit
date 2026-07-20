/// A first-level administrative division in Ethiopia.
///
/// This represents a regional state or a chartered city (for example,
/// `Oromia`, `Addis Ababa`). The data bundled with this package uses a
/// short machine-friendly `id` (e.g. `oromia`) and both English and Amharic
/// display names.
class EthioRegion {
  /// Creates a new `EthioRegion`.
  ///
  /// All parameters are required. `id` should be a stable, machine-friendly
  /// lowercase string without spaces (used as the lookup key in the data
  /// helpers). `name` is the English display name; `nameAmharic` is the
  /// Amharic / Ge'ez-script display name.
  const EthioRegion({
    required this.id,
    required this.name,
    required this.nameAmharic,
  });

  /// Stable machine-friendly identifier for the region (e.g. `oromia`).
  final String id;

  /// Human-readable English name for the region (e.g. `Oromia`).
  final String name;

  /// Human-readable Amharic name for the region (Ge'ez script).
  final String nameAmharic;

  @override
  String toString() => name;

  @override
  bool operator ==(Object other) {
    return other is EthioRegion &&
        other.id == id &&
        other.name == name &&
        other.nameAmharic == nameAmharic;
  }

  @override
  int get hashCode => Object.hash(id, name, nameAmharic);
}

/// A zone within a region.
///
/// Zones are a second-level administrative unit. Each `EthioZone` belongs to
/// a parent region via `regionId`. Zone names are provided in English and
/// Amharic where available. Note: zone names and counts can vary across
/// public documents; the bundled zone list is a conservative public reference
/// rather than a legal boundary registry.
class EthioZone {
  /// Creates a new `EthioZone`.
  const EthioZone({
    required this.id,
    required this.name,
    required this.nameAmharic,
    required this.regionId,
  });

  /// Stable machine-friendly identifier for the zone (e.g. `oromia_arsi`).
  final String id;

  /// English display name for the zone (e.g. `Arsi`).
  final String name;

  /// Amharic display name for the zone, when available.
  final String nameAmharic;

  /// The `id` of the parent region this zone belongs to.
  final String regionId;

  @override
  String toString() => name;

  @override
  bool operator ==(Object other) {
    return other is EthioZone &&
        other.id == id &&
        other.name == name &&
        other.nameAmharic == nameAmharic &&
        other.regionId == regionId;
  }

  @override
  int get hashCode => Object.hash(id, name, nameAmharic, regionId);
}

/// A woreda (district) within a zone.
///
/// Woreda-level data is intentionally not bundled in this release because a
/// trustworthy, up-to-date public source for all woredas across the newest
/// regions could not be confirmed. The type remains in the public API so
/// callers can work with woredas when they provide their own dataset.
class EthioWoreda {
  /// Creates a new `EthioWoreda`.
  const EthioWoreda({
    required this.id,
    required this.name,
    required this.nameAmharic,
    required this.zoneId,
  });

  /// Stable machine-friendly identifier for the woreda.
  final String id;

  /// English display name for the woreda.
  final String name;

  /// Amharic display name for the woreda, when available.
  final String nameAmharic;

  /// The `id` of the parent zone this woreda belongs to.
  final String zoneId;

  @override
  String toString() => name;

  @override
  bool operator ==(Object other) {
    return other is EthioWoreda &&
        other.id == id &&
        other.name == name &&
        other.nameAmharic == nameAmharic &&
        other.zoneId == zoneId;
  }

  @override
  int get hashCode => Object.hash(id, name, nameAmharic, zoneId);
}

/// Holds a nullable selection state for region, zone and woreda.
///
/// Each field is optional so the picker or a consumer can represent partial
/// selections (for example, only a selected region but no zone yet).
class EthioAddressSelection {
  /// Creates a new selection container.
  const EthioAddressSelection({
    this.regionId,
    this.zoneId,
    this.woredaId,
  });

  /// Selected region id, or `null` when none is selected.
  final String? regionId;

  /// Selected zone id, or `null` when none is selected.
  final String? zoneId;

  /// Selected woreda id, or `null` when none is selected.
  final String? woredaId;

  /// Returns a copy of this selection with the provided values replaced.
  ///
  /// Any argument that is `null` preserves the existing value from this
  /// selection.
  EthioAddressSelection copyWith({
    String? regionId,
    String? zoneId,
    String? woredaId,
  }) {
    return EthioAddressSelection(
      regionId: regionId ?? this.regionId,
      zoneId: zoneId ?? this.zoneId,
      woredaId: woredaId ?? this.woredaId,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is EthioAddressSelection &&
        other.regionId == regionId &&
        other.zoneId == zoneId &&
        other.woredaId == woredaId;
  }

  @override
  int get hashCode => Object.hash(regionId, zoneId, woredaId);
}

enum EthioAddressPickerLevel {
  /// Only show the Region field; no child fields are displayed.
  regionOnly,

  /// Show Region and Zone fields. Selecting a Region updates the Zone list
  /// and clears any previously-selected Zone/Woreda.
  regionZone,

  /// Show Region, Zone and Woreda fields. Selecting a parent clears its
  /// children (Region change clears Zone and Woreda; Zone change clears Woreda).
  regionZoneWoreda,
}
