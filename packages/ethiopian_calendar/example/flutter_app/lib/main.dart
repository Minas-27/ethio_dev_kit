import 'package:ethiopian_calendar/ethiopian_calendar.dart';
import 'package:flutter/material.dart';

void main() => runApp(const EthiopianCalendarDemoApp());

class EthiopianCalendarDemoApp extends StatelessWidget {
  const EthiopianCalendarDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ethiopian Calendar Demo',
      theme: ThemeData(colorSchemeSeed: Colors.green, useMaterial3: true),
      home: const ConverterPage(),
    );
  }
}

class ConverterPage extends StatefulWidget {
  const ConverterPage({super.key});

  @override
  State<ConverterPage> createState() => _ConverterPageState();
}

class _ConverterPageState extends State<ConverterPage> {
  DateTime _gregorian = DateTime(2026, 7, 9);

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _gregorian,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => _gregorian = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final eth = EthiopianDate.fromGregorian(_gregorian);
    final text = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Gregorian → Ethiopian')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Gregorian', style: text.labelLarge),
              Text(
                _gregorian.toIso8601String().split('T').first,
                style: text.headlineSmall,
              ),
              const SizedBox(height: 24),
              const Icon(Icons.swap_vert, size: 32),
              const SizedBox(height: 24),
              Text('Ethiopian', style: text.labelLarge),
              Text(
                eth.format('MMMM d, yyyy'),
                style: text.headlineSmall,
              ),
              Text(
                eth.format('MMMM d, yyyy', locale: EthiopianDateLocale.amharic),
                style: text.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                '${eth.weekday.english} • ${eth.weekday.amharic}'
                '${eth.isLeapYear ? '  (leap year)' : ''}',
                style: text.bodyMedium,
              ),
              const SizedBox(height: 32),
              FilledButton.icon(
                onPressed: _pickDate,
                icon: const Icon(Icons.calendar_today),
                label: const Text('Pick a Gregorian date'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
