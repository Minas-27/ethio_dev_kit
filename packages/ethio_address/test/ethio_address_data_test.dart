import 'package:ethio_address/ethio_address.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('bundled region count matches the current official first-level count',
      () {
    expect(allRegions(), hasLength(14));
  });

  test('every bundled zone points at a valid region', () {
    final regionIds = allRegions().map((region) => region.id).toSet();

    for (final regionId in regionIds) {
      for (final zone in zonesForRegion(regionId)) {
        expect(regionIds, contains(zone.regionId));
        expect(zonesForRegion(zone.regionId), contains(zone));
      }
    }
  });

  test('there are no orphaned woreda entries', () {
    for (final region in allRegions()) {
      for (final zone in zonesForRegion(region.id)) {
        expect(woredasForZone(zone.id), isEmpty);
      }
    }
  });

  test('zonesForRegion returns an empty list for unknown ids', () {
    expect(zonesForRegion('does-not-exist'), isEmpty);
  });
}
