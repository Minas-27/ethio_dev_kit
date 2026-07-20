import 'package:ethio_address/ethio_address.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('changing region updates zone options and clears zone selection',
      (tester) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    EthioAddressSelection? latestSelection;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: EthioAddressPicker(
              level: EthioAddressPickerLevel.regionZone,
              initialSelection: const EthioAddressSelection(
                regionId: 'oromia',
                zoneId: 'oromia_arsi',
              ),
              onChanged: (selection) {
                latestSelection = selection;
              },
            ),
          ),
        ),
      ),
    );

    expect(find.text('Arsi', skipOffstage: false), findsWidgets);

    await tester.tap(find.byKey(const ValueKey('ethio_address_region')));
    await tester.pumpAndSettle();
    expect(find.text('Afar', skipOffstage: false), findsWidgets);
    await tester.tap(find.text('Afar', skipOffstage: false).last);
    await tester.pumpAndSettle();

    expect(latestSelection?.regionId, 'afar');
    expect(latestSelection?.zoneId, isNull);

    await tester.tap(find.byKey(const ValueKey('ethio_address_zone')));
    await tester.pumpAndSettle();
    expect(find.text('Awsi', skipOffstage: false), findsWidgets);
    expect(find.text('Arsi', skipOffstage: false), findsNothing);
  });
}
