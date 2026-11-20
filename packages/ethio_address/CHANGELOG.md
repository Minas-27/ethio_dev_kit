# Changelog

## 0.1.2

- Fix: the default three-level `EthioAddressPicker` threw "Duplicate keys found"
  on its first build when nothing was selected, because the zone and woreda
  fields shared a key. Each field now has its own key, with a regression test.
- README badges and a screenshot on pub.dev.

## 0.1.1

- Dartdoc comments on the public API.

## 0.1.0

Initial release.

  12 regional states and 2 chartered cities.
  references. Woreda-level data is not bundled because I could not verify a
  trustworthy, up-to-date source without guessing.
## 0.1.1

- Documentation: added comprehensive DartDoc comments for the public API
  (models, data helpers, picker widget and parameters) to improve
  documentation coverage and consumer ergonomics.
