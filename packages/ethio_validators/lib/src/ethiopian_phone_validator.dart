/// The mobile network operators that hold Ethiopian mobile number ranges.
enum EthiopianCarrier {
  /// Ethio Telecom — national significant numbers beginning with `9`
  /// (local `09…`).
  ethioTelecom,

  /// Safaricom Ethiopia — national significant numbers beginning with `7`
  /// (local `07…`).
  safaricom,
}

/// The output styles supported by [EthiopianPhoneValidator.format].
enum PhoneNumberFormat {
  /// National/local form with a trunk `0`, grouped for readability, e.g.
  /// `0911 234 567`.
  local,

  /// International form with the `+251` country code, grouped, e.g.
  /// `+251 911 234 567`.
  international,

  /// Bare [E.164](https://en.wikipedia.org/wiki/E.164) form with no spaces,
  /// e.g. `+251911234567`. This is the canonical value returned by
  /// [EthiopianPhoneValidator.normalize].
  e164,
}

/// Validates, normalizes, and formats Ethiopian mobile phone numbers.
///
/// Ethiopian mobile numbers have a 9-digit *national significant number* (NSN)
/// whose first digit identifies the carrier:
///
/// - `9…` → [EthiopianCarrier.ethioTelecom] (written locally as `09XXXXXXXX`)
/// - `7…` → [EthiopianCarrier.safaricom] (written locally as `07XXXXXXXX`)
///
/// The following input forms are all accepted and treated as equivalent, with
/// spaces, dashes, dots, and parentheses ignored:
///
/// - `09XXXXXXXX` / `07XXXXXXXX` (local, with trunk `0`)
/// - `2519XXXXXXXX` / `2517XXXXXXXX` (country code, no `+`)
/// - `+2519XXXXXXXX` / `+2517XXXXXXXX` (E.164)
///
/// All members are static; this class is not meant to be instantiated.
class EthiopianPhoneValidator {
  const EthiopianPhoneValidator._();

  /// Ethiopia's international dialing country code, without the leading `+`.
  static const String countryCode = '251';

  /// Valid leading digits of the national significant number, by carrier.
  static const Map<String, EthiopianCarrier> _carrierByLeadingDigit = {
    '9': EthiopianCarrier.ethioTelecom,
    '7': EthiopianCarrier.safaricom,
  };

  /// Returns `true` if [input] is a valid Ethiopian mobile number in any of
  /// the accepted formats.
  static bool isValid(String input) => _toNsn(input) != null;

  /// Returns the carrier that owns [input], or `null` if [input] is not a
  /// valid Ethiopian mobile number.
  static EthiopianCarrier? carrierOf(String input) {
    final nsn = _toNsn(input);
    if (nsn == null) return null;
    return _carrierByLeadingDigit[nsn[0]];
  }

  /// Normalizes [input] to canonical E.164 form (`+2519XXXXXXXX`).
  ///
  /// Throws a [FormatException] if [input] is not a valid Ethiopian mobile
  /// number. Use [tryNormalize] for a non-throwing variant.
  static String normalize(String input) {
    final result = tryNormalize(input);
    if (result == null) {
      throw FormatException('Invalid Ethiopian mobile number', input);
    }
    return result;
  }

  /// Like [normalize], but returns `null` instead of throwing when [input] is
  /// invalid.
  static String? tryNormalize(String input) {
    final nsn = _toNsn(input);
    if (nsn == null) return null;
    return '+$countryCode$nsn';
  }

  /// Formats [input] in the requested [format] (defaults to
  /// [PhoneNumberFormat.local]).
  ///
  /// Throws a [FormatException] if [input] is not a valid Ethiopian mobile
  /// number.
  static String format(
    String input, {
    PhoneNumberFormat format = PhoneNumberFormat.local,
  }) {
    final nsn = _toNsn(input);
    if (nsn == null) {
      throw FormatException('Invalid Ethiopian mobile number', input);
    }
    // NSN is always 9 digits; group the last 6 as 3-3 for readability.
    final head = nsn.substring(0, 3); // e.g. 911
    final mid = nsn.substring(3, 6); // e.g. 234
    final tail = nsn.substring(6, 9); // e.g. 567
    switch (format) {
      case PhoneNumberFormat.local:
        return '0$head $mid $tail';
      case PhoneNumberFormat.international:
        return '+$countryCode $head $mid $tail';
      case PhoneNumberFormat.e164:
        return '+$countryCode$nsn';
    }
  }

  /// Reduces any accepted input form to its bare 9-digit national significant
  /// number, or returns `null` if [input] is not a valid Ethiopian mobile
  /// number.
  static String? _toNsn(String input) {
    if (input.isEmpty) return null;

    // A leading '+' is meaningful (E.164); any other non-digit is treated as
    // separator noise and dropped.
    final hasPlus = input.trimLeft().startsWith('+');
    final digits = input.replaceAll(RegExp(r'\D'), '');
    if (digits.isEmpty) return null;

    String nsn;
    if (digits.startsWith(countryCode) &&
        digits.length == countryCode.length + 9) {
      // 2519XXXXXXXX or +2519XXXXXXXX
      nsn = digits.substring(countryCode.length);
    } else if (hasPlus) {
      // A '+' that isn't followed by the Ethiopian country code is not a valid
      // Ethiopian number (e.g. +1..., +2519 with wrong length).
      return null;
    } else if (digits.length == 10 && digits.startsWith('0')) {
      // 09XXXXXXXX / 07XXXXXXXX
      nsn = digits.substring(1);
    } else if (digits.length == 9) {
      // Bare NSN: 9XXXXXXXX / 7XXXXXXXX
      nsn = digits;
    } else {
      return null;
    }

    if (nsn.length != 9) return null;
    if (!_carrierByLeadingDigit.containsKey(nsn[0])) return null;
    return nsn;
  }
}
