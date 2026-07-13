import 'dart:async';

import 'package:amharic_stt/amharic_stt.dart';
import 'package:flutter/material.dart';

void main() => runApp(const AmharicSttDemo());

/// A minimal demo: check availability, toggle listening with a mic button, and
/// show live partial + final transcription. When Amharic isn't supported on the
/// device, a clear message is shown instead of a broken mic.
class AmharicSttDemo extends StatelessWidget {
  const AmharicSttDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'amharic_stt example',
      theme: ThemeData(
          colorSchemeSeed: const Color(0xFF117A3D), useMaterial3: true),
      home: const _HomePage(),
    );
  }
}

class _HomePage extends StatefulWidget {
  const _HomePage();

  @override
  State<_HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<_HomePage> {
  final AmharicSpeechRecognizer _recognizer = AmharicSpeechRecognizer();
  StreamSubscription<SpeechResult>? _sub;

  /// null = still checking; true/false = probe result.
  bool? _available;
  bool _listening = false;
  String _transcript = '';
  String? _error;

  @override
  void initState() {
    super.initState();
    _checkAvailability();
  }

  @override
  void dispose() {
    _sub?.cancel();
    _recognizer.dispose();
    super.dispose();
  }

  Future<void> _checkAvailability() async {
    final available = await _recognizer.isAvailable();
    if (!mounted) return;
    setState(() => _available = available);
  }

  Future<void> _toggleListening() async {
    if (_listening) {
      await _recognizer.stopListening();
      if (mounted) setState(() => _listening = false);
      return;
    }

    setState(() {
      _error = null;
      _transcript = '';
    });

    _sub ??= _recognizer.results.listen(
      (result) {
        if (!mounted) return;
        setState(() {
          _transcript = result.transcript;
          if (result.isFinal) _listening = false;
        });
      },
      onError: (Object e) {
        if (!mounted) return;
        setState(() {
          _listening = false;
          _error = e is AmharicSttException
              ? '${e.kind.name}: ${e.message}'
              : e.toString();
        });
      },
    );

    try {
      await _recognizer.startListening();
      if (mounted) setState(() => _listening = true);
    } on AmharicSttException catch (e) {
      if (mounted) {
        setState(() => _error = '${e.kind.name}: ${e.message}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Amharic STT — የአማርኛ ንግግር')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(child: _buildBody(context)),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    final theme = Theme.of(context);

    if (_available == null) {
      return const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Checking Amharic availability…'),
        ],
      );
    }

    if (_available == false) {
      // Honest, visible message when the device can't do Amharic.
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.mic_off, size: 64, color: theme.colorScheme.error),
          const SizedBox(height: 16),
          Text(
            'Amharic speech recognition is not available on this device.',
            textAlign: TextAlign.center,
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'The platform recognizer does not support the am-ET locale here. '
            'See the package README for the platform/OS support matrix.',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall,
          ),
        ],
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Text(
              _transcript.isEmpty
                  ? (_listening
                      ? 'Listening… speak Amharic'
                      : 'Tap the mic to start')
                  : _transcript,
              textAlign: TextAlign.center,
              style: theme.textTheme.headlineSmall,
            ),
          ),
        ),
        if (_error != null) ...[
          const SizedBox(height: 12),
          Text(
            _error!,
            key: const Key('error-text'),
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium
                ?.copyWith(color: theme.colorScheme.error),
          ),
        ],
        const SizedBox(height: 24),
        FloatingActionButton.large(
          onPressed: _toggleListening,
          tooltip: _listening ? 'Stop' : 'Start listening',
          backgroundColor: _listening ? theme.colorScheme.error : null,
          child: Icon(_listening ? Icons.stop : Icons.mic),
        ),
        const SizedBox(height: 12),
        Text(_listening ? 'Tap to stop' : 'Tap to start'),
      ],
    );
  }
}
