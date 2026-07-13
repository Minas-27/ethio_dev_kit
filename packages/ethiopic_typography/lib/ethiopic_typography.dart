/// Drop-in bilingual (English/Amharic) Flutter theming with the Manrope +
/// Noto Sans Ethiopic font pairing.
///
/// Latin text renders in Manrope; Ge'ez script automatically falls back to
/// Noto Sans Ethiopic — no per-widget font handling required. Both families
/// are bundled with this package as variable fonts (SIL Open Font License
/// 1.1), so the pairing works fully offline with no runtime font fetching.
///
/// ```dart
/// import 'package:ethiopic_typography/ethiopic_typography.dart';
///
/// MaterialApp(
///   theme: ethioAppTheme(seedColor: Colors.green),
///   darkTheme: ethioDarkAppTheme(seedColor: Colors.green),
///   themeMode: ThemeMode.system,
///   home: const Text('Welcome — እንኳን ደህና መጡ'),
/// );
/// ```
library;

export 'src/ethio_app_theme.dart';
export 'src/ethio_fonts.dart';
export 'src/ethio_text_theme.dart';
