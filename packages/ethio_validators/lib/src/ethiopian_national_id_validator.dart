/// Validates, normalizes, and formats Ethiopian Fayda National ID numbers.
///
/// Fayda IDs are exactly 12 numeric digits. There is no publicly documented
/// checksum algorithm, region-encoding, or structural pattern.
///
/// **Important Limitation:**
/// This validates basic 12-digit numeric format only. Because there is no
/// publicly documented checksum for Fayda IDs, this validator cannot detect a
/// typo within an otherwise correctly-formatted 12-digit number. It also does
/// NOT verify that an ID is real, active, or belongs to a specific person.
/// For actual identity verification, apps must integrate with the official
/// Fayda eKYC API via NIDP partnership.
///
/// All members are static; this class is not meant to be instantiated.
class EthiopianNationalIdValidator {
  const EthiopianNationalIdValidator._();

  /// Returns `true` if [input] is a valid 12-digit Fayda ID, ignoring spaces
  /// and dashes.
  static bool isValid(String input) => tryNormalize(input) != null;

  /// Normalizes [input] to a clean 12-digit string by stripping spaces and dashes.
  ///
  /// Throws a [FormatException] if [input] is not exactly 12 digits.
  /// Use [tryNormalize] for a non-throwing variant.
  static String normalize(String input) {
    final result = tryNormalize(input);
    if (result == null) {
      throw FormatException('Invalid Ethiopian Fayda ID', input);
    }
    return result;
  }

  /// Like [normalize], but returns `null` instead of throwing when [input] is
  /// invalid.
  static String? tryNormalize(String input) {
    if (input.isEmpty) return null;

    final digits = input.replaceAll(RegExp(r'[\s-]'), '');
    
    // If there are any non-digit characters left, it's invalid.
    if (!RegExp(r'^\d{12}$').hasMatch(digits)) return null;

    return digits;
  }

  /// Formats [input] into a 4-digit grouped display string (e.g. `1234 5678 9012`).
  ///
  /// Throws a [FormatException] if [input] is not a valid 12-digit Fayda ID.
  static String format(String input) {
    final id = tryNormalize(input);
    if (id == null) {
      throw FormatException('Invalid Ethiopian Fayda ID', input);
    }
    
    final group1 = id.substring(0, 4);
    final group2 = id.substring(4, 8);
    final group3 = id.substring(8, 12);
    
    return '$group1 $group2 $group3';
  }
}
