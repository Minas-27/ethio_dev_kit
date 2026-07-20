class EthioRegion {
  const EthioRegion({
    required this.id,
    required this.name,
    required this.nameAmharic,
  });

  final String id;
  final String name;
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

class EthioZone {
  const EthioZone({
    required this.id,
    required this.name,
    required this.nameAmharic,
    required this.regionId,
  });

  final String id;
  final String name;
  final String nameAmharic;
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

class EthioWoreda {
  const EthioWoreda({
    required this.id,
    required this.name,
    required this.nameAmharic,
    required this.zoneId,
  });

  final String id;
  final String name;
  final String nameAmharic;
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

class EthioAddressSelection {
  const EthioAddressSelection({
    this.regionId,
    this.zoneId,
    this.woredaId,
  });

  final String? regionId;
  final String? zoneId;
  final String? woredaId;

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
  regionOnly,
  regionZone,
  regionZoneWoreda,
}
