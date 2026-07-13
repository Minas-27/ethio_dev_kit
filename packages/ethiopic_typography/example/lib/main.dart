import 'package:ethiopic_typography/ethiopic_typography.dart';
import 'package:flutter/material.dart';

void main() => runApp(const EthioTypographyDemo());

/// Demonstrates [ethioAppTheme] / [ethioDarkAppTheme] with a light/dark toggle
/// and mixed English + Amharic text across every Material text role.
class EthioTypographyDemo extends StatefulWidget {
  const EthioTypographyDemo({super.key});

  @override
  State<EthioTypographyDemo> createState() => _EthioTypographyDemoState();
}

class _EthioTypographyDemoState extends State<EthioTypographyDemo> {
  static const Color _seed = Color(0xFF117A3D); // Ethiopian green.

  ThemeMode _mode = ThemeMode.light;

  void _toggleMode() {
    setState(() {
      _mode = _mode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ethiopic_typography',
      debugShowCheckedModeBanner: false,
      theme: ethioAppTheme(seedColor: _seed),
      darkTheme: ethioDarkAppTheme(seedColor: _seed),
      themeMode: _mode,
      home: _DemoScreen(mode: _mode, onToggleMode: _toggleMode),
    );
  }
}

class _DemoScreen extends StatelessWidget {
  const _DemoScreen({required this.mode, required this.onToggleMode});

  final ThemeMode mode;
  final VoidCallback onToggleMode;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final isDark = mode == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ethiopic Typography — ኢትዮፒክ ጽሑፍ'),
        actions: [
          IconButton(
            tooltip: isDark ? 'Switch to light' : 'Switch to dark',
            onPressed: onToggleMode,
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text('Display — ማሳያ', style: text.displaySmall),
          const SizedBox(height: 12),
          Text('Headline — አርዕስት', style: text.headlineMedium),
          const SizedBox(height: 12),
          Text('Title — ርዕስ', style: text.titleLarge),
          const SizedBox(height: 20),
          Text(
            'Body: The quick brown fox. ፈጣኑ ቡናማ ቀበሮ ሰነፉን ውሻ ዘሎ አለፈ። '
            'English and Amharic sit side by side in one paragraph, each glyph '
            'rendered by the right font automatically — ምንም ተጨማሪ ማዋቀር '
            'አያስፈልግም።',
            style: text.bodyLarge,
          ),
          const SizedBox(height: 20),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Label — መለያ', style: text.labelLarge),
                  const SizedBox(height: 8),
                  Text('ሰላም ለዓለም — Hello, world!', style: text.titleMedium),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          FilledButton(
            onPressed: () {},
            child: const Text('Continue — ቀጥል'),
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: () {},
            child: const Text('Cancel — ሰርዝ'),
          ),
          const SizedBox(height: 24),
          Text(
            'One-off style via EthioTextTheme.style():',
            style: text.bodySmall,
          ),
          const SizedBox(height: 6),
          Text(
            'Custom 22px — ብጁ ጽሑፍ',
            style: EthioTextTheme.style(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}
