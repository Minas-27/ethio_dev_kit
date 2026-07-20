# ethio_address

<!-- Badges: replace Minas-27 once the repo is published, then uncomment. -->
<!--
[![pub package](https://img.shields.io/pub/v/ethio_address.svg)](https://pub.dev/packages/ethio_address)
[![CI](https://github.com/Minas-27/ethio_dev_kit/actions/workflows/ci.yaml/badge.svg)](https://github.com/Minas-27/ethio_dev_kit/actions/workflows/ci.yaml)
[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
-->

Ethiopian administrative division data and cascading picker widgets for Flutter.
The package ships a **pure Dart data layer** plus a **Flutter Region -> Zone ->
Woreda picker** that is easy to embed in a form.

## Data freshness

**As of 2026-06-21** for the bundled region list and **2026-05-18** for the
bundled zone list.

Sources used:

- [Regions of Ethiopia](https://en.wikipedia.org/wiki/Regions_of_Ethiopia)
  (page revision timestamp: 2026-06-21). This page currently lists **12
  regional states and 2 chartered cities**.
- [List of zones of Ethiopia](https://en.wikipedia.org/wiki/List_of_zones_of_Ethiopia)
  (page revision timestamp: 2026-05-18). This source explicitly notes that zone
  names and counts vary across public documents, so the bundled zone dataset is
  best treated as a current public reference list, not a legal boundary registry.

Woreda-level data is **not bundled**. I could not verify a trustworthy, current
source for a complete woreda dataset without guessing, so `woredasForZone()`
returns an empty list for now.

Administrative boundaries can change again. If you spot outdated data, please
file an issue so the package can be updated.

## Features

- Pure Dart data models for Ethiopian regions, zones, and woredas.
- Bundled current first-level divisions: 12 regional states + 2 chartered cities.
- Zone lookup helpers for the bundled dataset.
- Flutter `EthioAddressPicker` with cascading Region -> Zone -> Woreda fields.
- Form-friendly widget built from standard `DropdownButtonFormField`s.

## Install

```yaml
dependencies:
  ethio_address: ^0.1.0
```

Then:

```dart
import 'package:ethio_address/ethio_address.dart';
```

## Quick start

```dart
final regions = allRegions();
final zones = zonesForRegion('oromia');
final woredas = woredasForZone('some_zone_id');
```

## API

### Data models

| Member | Description |
| --- | --- |
| `EthioRegion` | `id`, `name`, `nameAmharic` for a first-level administrative division. |
| `EthioZone` | `id`, `name`, `nameAmharic`, `regionId` for a zone. |
| `EthioWoreda` | `id`, `name`, `nameAmharic`, `zoneId` for a woreda. |
| `EthioAddressSelection` | Nullable region / zone / woreda selection state for the picker. |
| `EthioAddressPickerLevel` | `regionOnly`, `regionZone`, `regionZoneWoreda`. |

### Lookup helpers

| Member | Description |
| --- | --- |
| `allRegions()` | Returns the bundled first-level administrative divisions. |
| `zonesForRegion(String regionId)` | Returns the bundled zones for one region. |
| `woredasForZone(String zoneId)` | Returns the bundled woredas for one zone. Currently empty. |

### Widget

| Member | Description |
| --- | --- |
| `EthioAddressPicker` | Cascading Region -> Zone -> Woreda picker built from `DropdownButtonFormField`s. |

## Example

A runnable Flutter demo lives in [`example/`](example/).

```bash
cd example
flutter run
```

## Notes

- The region list is current as of the dates above, but administrative
divisions can change again.
- The bundled zone data is intentionally conservative. Where a current public
  list could be verified, it is included; where it could not, the package leaves
  that subdivision out rather than inventing one.
- Woreda data is omitted until a trustworthy current source can be verified.

## Contributing

Part of the [ethio_dev_kit](https://github.com/Minas-27/ethio_dev_kit)
monorepo. Issues and pull requests are welcome. Please run `flutter analyze`
and `flutter test` before opening a PR.

## License

MIT — see [`LICENSE`](LICENSE).
