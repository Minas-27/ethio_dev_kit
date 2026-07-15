import 'package:ethio_holidays/ethio_holidays.dart';

void main() {
  final years = [2026, 2027];

  for (final year in years) {
    print('\n================================');
    print('  ETHIOPIAN HOLIDAYS FOR $year');
    print('================================');
    
    final holidays = holidaysForYear(year);
    
    for (final holiday in holidays) {
      final dateStr = holiday.date.toString().substring(0, 10);
      final estimatedStr = holiday.isEstimated ? ' (Estimated ±1 day)' : '';
      
      print('$dateStr | ${holiday.name.padRight(25)} | ${holiday.nameAmharic}$estimatedStr');
    }
  }
}
