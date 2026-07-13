# ethio_validators

<!-- Badges: replace <OWNER> once the repo is published, then uncomment. -->
<!--
[![pub package](https://img.shields.io/pub/v/ethio_validators.svg)](https://pub.dev/packages/ethio_validators)
[![CI](https://github.com/<OWNER>/ethio_dev_kit/actions/workflows/ci.yaml/badge.svg)](https://github.com/<OWNER>/ethio_dev_kit/actions/workflows/ci.yaml)
[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
-->

Validation and formatting utilities for Ethiopian-specific data:

- **`EthiopianPhoneValidator`** — validate, normalize, and format Ethiopian
  mobile numbers across **Ethio Telecom** (`09…`) and **Safaricom Ethiopia**
  (`07…`) ranges.
- **`EtbFormatter`** — format and parse **Ethiopian Birr (ETB)** currency
  amounts.

The package is **pure Dart with zero dependencies**, so it runs everywhere Dart
runs — Flutter apps, server-side Dart, and command-line tools.

## Install

```yaml
dependencies:
  ethio_validators: ^0.1.0
```

Then:

```dart
import 'package:ethio_validators/ethio_validators.dart';
```

## Quick start

### Phone numbers

```dart
// All of these are the same number in different formats:
EthiopianPhoneValidator.isValid('0911234567');       // true
EthiopianPhoneValidator.isValid('+251 91 123 4567'); // true
EthiopianPhoneValidator.isValid('251911234567');     // true

// Normalize any accepted form to canonical E.164:
EthiopianPhoneValidator.normalize('0911 234 567');   // '+251911234567'

// Which carrier?
EthiopianPhoneValidator.carrierOf('0711234567');     // EthiopianCarrier.safaricom

// Format for display:
EthiopianPhoneValidator.format('+251911234567');     // '0911 234 567'  (local)
EthiopianPhoneValidator.format(
  '0911234567',
  format: PhoneNumberFormat.international,            // '+251 911 234 567'
);

// Invalid input throws on normalize/format; use the try* / isValid variants
// to avoid exceptions:
EthiopianPhoneValidator.tryNormalize('0111234567');  // null (landline)
```

Accepted input forms (separators such as spaces, `-`, `.`, and `()` are
ignored): `09XXXXXXXX`, `07XXXXXXXX`, `2519XXXXXXXX`, `2517XXXXXXXX`,
`+2519XXXXXXXX`, `+2517XXXXXXXX`, and the bare 9-digit `9XXXXXXXX` / `7XXXXXXXX`.

### ETB currency

```dart
const etb = EtbFormatter();               // suffix style, 2 decimals
etb.format(1250);                         // '1,250.00 ETB'
etb.format(-1250.5);                      // '-1,250.50 ETB'
etb.parse('1,250.00 ETB');                // 1250.0

const prefixed = EtbFormatter(symbolPosition: EtbSymbolPosition.prefix);
prefixed.format(1250);                    // 'ETB 1,250.00'

const birr = EtbFormatter(symbol: 'Br', decimalDigits: 0);
birr.format(1250.7);                      // '1,251 Br'
```

## API

### `EthiopianPhoneValidator` (all static)

| Member | Description |
| --- | --- |
| `isValid(String)` → `bool` | Whether the input is a valid Ethiopian mobile number. |
| `carrierOf(String)` → `EthiopianCarrier?` | The owning carrier, or `null` if invalid. |
| `normalize(String)` → `String` | Canonical E.164 (`+2519XXXXXXXX`); throws `FormatException` if invalid. |
| `tryNormalize(String)` → `String?` | Like `normalize`, but returns `null` on invalid input. |
| `format(String, {PhoneNumberFormat})` → `String` | Formats as `local`, `international`, or `e164`; throws if invalid. |
| `countryCode` | `'251'`. |

`EthiopianCarrier` = `{ ethioTelecom, safaricom }`.
`PhoneNumberFormat` = `{ local, international, e164 }`.

### `EtbFormatter`

| Member | Description |
| --- | --- |
| `EtbFormatter({symbol, symbolPosition, decimalDigits, thousandsSeparator, decimalSeparator})` | Immutable, reusable formatter. Separators must differ. |
| `format(num)` → `String` | Formats an amount; groups thousands, rounds to `decimalDigits`. Throws on non-finite input. |
| `parse(String)` → `num` | Parses a formatted amount back to a number; throws `FormatException` if none found. |
| `tryParse(String)` → `double?` | Like `parse`, but returns `null` on invalid input. |

`EtbSymbolPosition` = `{ suffix, prefix }`.

## Notes on carrier ranges

Ethiopian mobile numbers use a 9-digit national significant number whose first
digit identifies the carrier: `9…` for Ethio Telecom and `7…` for Safaricom
Ethiopia. This library validates structure and carrier prefix; it does not
guarantee that a specific number has been allocated or is currently active.

## Example

A runnable command-line demo (a small validation + formatting "form" flow) is in
[`example/`](example/):

```bash
dart run example/ethio_validators_example.dart
```

## Contributing

Part of the [ethio_dev_kit](https://github.com/abroid-dev/ethio_dev_kit)
monorepo. Issues and pull requests are welcome — please run `dart analyze` and
`dart test` (both must be clean/green) before opening a PR.

## License

MIT — see [`LICENSE`](LICENSE).
