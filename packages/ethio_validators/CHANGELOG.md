# Changelog

## 0.2.0

- Added `EthiopianNationalIdValidator` to validate and format 12-digit numeric Fayda IDs.

## 0.1.0

Initial release.

- `EthiopianPhoneValidator` — validate, normalize, and format Ethiopian mobile
  numbers across Ethio Telecom (`9…`) and Safaricom Ethiopia (`7…`) ranges.
  - Accepts `09XXXXXXXX`, `2519XXXXXXXX`, `+2519XXXXXXXX`, bare `9XXXXXXXX`, and
    the `7…` equivalents, ignoring spaces, dashes, dots, and parentheses.
  - `isValid`, `carrierOf`, `normalize` / `tryNormalize` (to E.164), and
    `format` (local / international / E.164).
- `EtbFormatter` — format and parse Ethiopian Birr amounts.
  - Configurable symbol, prefix/suffix position, decimal digits, and thousands/
    decimal separators.
  - `format` with correct grouping, sign handling, and rounding; `parse` /
    `tryParse` back to a number, tolerant of symbol and separator noise.
- Pure Dart, zero runtime dependencies.
- Full unit test suite and a runnable command-line example.
