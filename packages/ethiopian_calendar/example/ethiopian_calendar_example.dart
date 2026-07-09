// A minimal command-line demonstration of the ethiopian_calendar package.
//
// Run with:  dart run example/ethiopian_calendar_example.dart
//
// ignore_for_file: avoid_print — printing to stdout is the point of a CLI demo.
import 'package:ethiopian_calendar/ethiopian_calendar.dart';

void main() {
  // Gregorian -> Ethiopian.
  final today = EthiopianDate.fromGregorian(DateTime(2026, 7, 9));
  print('Gregorian 2026-07-09 is:');
  print('  ISO      : $today');
  print('  English  : ${today.format('MMMM d, yyyy')}');
  print('  Amharic  : '
      '${today.format('MMMM d, yyyy', locale: EthiopianDateLocale.amharic)}');
  print('  Weekday  : ${today.weekday.english} / ${today.weekday.amharic}');
  print('  Leap year: ${today.isLeapYear}');

  // Ethiopian -> Gregorian.
  final newYear = EthiopianDate(2017, 1, 1);
  print('\nEthiopian New Year 2017 (Meskerem 1) falls on Gregorian '
      '${newYear.toGregorian().toIso8601String().split('T').first}.');

  // Date arithmetic.
  final exam = EthiopianDate(2016, 10, 15);
  final deadline = exam.addDays(45);
  print('\n45 days after ${exam.format('MMMM d, yyyy')} is '
      '${deadline.format('MMMM d, yyyy')} '
      '(${deadline.difference(exam)} days).');
}
