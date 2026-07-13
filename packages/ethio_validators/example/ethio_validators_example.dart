// A minimal command-line demonstration of the ethio_validators package,
// modelled as a small "checkout form" that validates a phone number and
// formats an order total.
//
// Run with:  dart run example/ethio_validators_example.dart
//
// ignore_for_file: avoid_print — printing to stdout is the point of a CLI demo.
import 'package:ethio_validators/ethio_validators.dart';

void main() {
  print('=== Ethio Validators — checkout form demo ===\n');

  // --- Phone field ----------------------------------------------------------
  // Simulate users typing the same number in different ways, plus a bad entry.
  const phoneInputs = [
    '0911234567', // Ethio Telecom, local
    '+251 71 123 4567', // Safaricom, international with spaces
    '251911234567', // country code, no plus
    '0111234567', // landline — invalid as a mobile
  ];

  print('Phone field:');
  for (final input in phoneInputs) {
    if (EthiopianPhoneValidator.isValid(input)) {
      final carrier = EthiopianPhoneValidator.carrierOf(input);
      print('  ✅ "$input"');
      print('       display : ${EthiopianPhoneValidator.format(input)}');
      print('       e164    : ${EthiopianPhoneValidator.normalize(input)}');
      print('       carrier : ${_carrierName(carrier!)}');
    } else {
      print('  ❌ "$input" — please enter a valid mobile number.');
    }
  }

  // --- Amount field ---------------------------------------------------------
  print('\nOrder summary:');
  const etb = EtbFormatter(); // '1,250.00 ETB'
  const subtotal = 1250.0;
  const shipping = 75.5;
  const discount = -125.0;
  final total = subtotal + shipping + discount;

  print('  Subtotal : ${etb.format(subtotal)}');
  print('  Shipping : ${etb.format(shipping)}');
  print('  Discount : ${etb.format(discount)}');
  print('  Total    : ${etb.format(total)}');

  // Parse a user-typed amount back into a number (e.g. a "custom tip" field).
  const typed = 'ETB 1,200.50';
  final parsed =
      EtbFormatter(symbolPosition: EtbSymbolPosition.prefix).parse(typed);
  print('\nParsed "$typed" -> $parsed (${parsed.runtimeType})');
}

String _carrierName(EthiopianCarrier carrier) => switch (carrier) {
      EthiopianCarrier.ethioTelecom => 'Ethio Telecom',
      EthiopianCarrier.safaricom => 'Safaricom Ethiopia',
    };
