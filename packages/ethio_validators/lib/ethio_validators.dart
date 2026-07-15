/// Validation and formatting utilities for Ethiopian-specific data.
///
/// - [EthiopianPhoneValidator] — validate, normalize, and format Ethiopian
///   mobile numbers across Ethio Telecom (`09…`) and Safaricom (`07…`) ranges.
/// - [EthiopianNationalIdValidator] — validate and format 12-digit Fayda IDs.
/// - [EtbFormatter] — format and parse Ethiopian Birr (ETB) currency amounts.
///
/// Pure Dart with zero runtime dependencies, so it runs everywhere Dart runs.
///
/// ```dart
/// import 'package:ethio_validators/ethio_validators.dart';
///
/// EthiopianPhoneValidator.isValid('0911234567');        // true
/// EthiopianPhoneValidator.normalize('0911 234 567');    // '+251911234567'
///
/// const etb = EtbFormatter();
/// etb.format(1250.5);                                   // '1,250.50 ETB'
/// etb.parse('1,250.50 ETB');                            // 1250.5
/// ```
library;

export 'src/etb_formatter.dart';
export 'src/ethiopian_national_id_validator.dart';
export 'src/ethiopian_phone_validator.dart';
