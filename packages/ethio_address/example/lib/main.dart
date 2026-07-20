import 'package:ethio_address/ethio_address.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const EthioAddressExampleApp());
}

class EthioAddressExampleApp extends StatelessWidget {
  const EthioAddressExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0F766E)),
        useMaterial3: true,
      ),
      home: const EthioAddressExamplePage(),
    );
  }
}

class EthioAddressExamplePage extends StatefulWidget {
  const EthioAddressExamplePage({super.key});

  @override
  State<EthioAddressExamplePage> createState() => _EthioAddressExamplePageState();
}

class _EthioAddressExamplePageState extends State<EthioAddressExamplePage> {
  EthioAddressSelection _selection = const EthioAddressSelection();

  String _labelForRegion(String? regionId) {
    if (regionId == null) {
      return 'Not selected';
    }

    for (final region in allRegions()) {
      if (region.id == regionId) {
        return region.name;
      }
    }

    return regionId;
  }

  String _labelForZone(String? regionId, String? zoneId) {
    if (regionId == null || zoneId == null) {
      return 'Not selected';
    }

    for (final zone in zonesForRegion(regionId)) {
      if (zone.id == zoneId) {
        return zone.name;
      }
    }

    return zoneId;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ethio_address example')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Form(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Select a region, then a zone. Woreda data is not bundled yet.',
                  ),
                  const SizedBox(height: 16),
                  EthioAddressPicker(
                    level: EthioAddressPickerLevel.regionZoneWoreda,
                    onChanged: (selection) {
                      setState(() {
                        _selection = selection;
                      });
                    },
                  ),
                  const SizedBox(height: 24),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Region: ${_labelForRegion(_selection.regionId)}'),
                          const SizedBox(height: 8),
                          Text('Zone: ${_labelForZone(_selection.regionId, _selection.zoneId)}'),
                          const SizedBox(height: 8),
                          Text(
                              'Woreda: ${_selection.woredaId ?? 'Not selected'}',
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
