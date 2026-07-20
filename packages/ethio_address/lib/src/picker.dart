import 'package:flutter/material.dart';

import 'data.dart';
import 'models.dart';

/// A cascading location picker for Ethiopian administrative divisions.
///
/// `EthioAddressPicker` presents up to three cascading dropdown fields:
/// Region -> Zone -> Woreda. Which fields are shown is controlled by
/// [level]. Selecting a parent field updates the available child options and
/// clears any previously-selected child values. For example, changing the
/// selected Region clears the Zone and Woreda selections; changing the Zone
/// clears the Woreda selection.
class EthioAddressPicker extends StatefulWidget {
  /// Creates an `EthioAddressPicker`.
  ///
  /// - [level] controls which fields are visible. Defaults to showing all
  ///   three levels.
  /// - [initialSelection] pre-populates the picker; invalid or unknown ids are
  ///   ignored and the control will normalise them on init.
  /// - [onChanged] is called whenever the selection changes; it receives an
  ///   `EthioAddressSelection` with nullable `regionId`, `zoneId`, and
  ///   `woredaId` fields.
  /// - [regionDecoration], [zoneDecoration], and [woredaDecoration] allow the
  ///   caller to customise the `InputDecoration` for each dropdown.
  const EthioAddressPicker({
    super.key,
    this.level = EthioAddressPickerLevel.regionZoneWoreda,
    this.initialSelection,
    this.onChanged,
    this.regionDecoration,
    this.zoneDecoration,
    this.woredaDecoration,
  });

  /// Which levels the picker should display.
  final EthioAddressPickerLevel level;

  /// An optional initial selection to pre-populate the fields.
  final EthioAddressSelection? initialSelection;

  /// Called when the selection changes.
  final ValueChanged<EthioAddressSelection>? onChanged;

  /// Optional decoration for the Region field.
  final InputDecoration? regionDecoration;

  /// Optional decoration for the Zone field.
  final InputDecoration? zoneDecoration;

  /// Optional decoration for the Woreda field.
  final InputDecoration? woredaDecoration;

  @override
  State<EthioAddressPicker> createState() => _EthioAddressPickerState();
}

class _EthioAddressPickerState extends State<EthioAddressPicker> {
  String? _regionId;
  String? _zoneId;
  String? _woredaId;

  @override
  void initState() {
    super.initState();
    _regionId = widget.initialSelection?.regionId;
    _zoneId = widget.initialSelection?.zoneId;
    _woredaId = widget.initialSelection?.woredaId;
    _normalizeSelection();
  }

  @override
  void didUpdateWidget(covariant EthioAddressPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialSelection != widget.initialSelection) {
      _regionId = widget.initialSelection?.regionId;
      _zoneId = widget.initialSelection?.zoneId;
      _woredaId = widget.initialSelection?.woredaId;
      _normalizeSelection();
    }
  }

  void _normalizeSelection() {
    if (_regionId == null || regionById(_regionId!) == null) {
      _regionId = null;
      _zoneId = null;
      _woredaId = null;
      return;
    }

    final zones = zonesForRegion(_regionId!);
    if (_zoneId == null || zones.every((zone) => zone.id != _zoneId)) {
      _zoneId = null;
      _woredaId = null;
      return;
    }

    final woredas = woredasForZone(_zoneId!);
    if (_woredaId == null ||
        woredas.every((woreda) => woreda.id != _woredaId)) {
      _woredaId = null;
    }
  }

  void _emitChanged() {
    widget.onChanged?.call(
      EthioAddressSelection(
        regionId: _regionId,
        zoneId: _zoneId,
        woredaId: _woredaId,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final regions = allRegions();
    final zones =
        _regionId == null ? const <EthioZone>[] : zonesForRegion(_regionId!);
    final woredas =
        _zoneId == null ? const <EthioWoreda>[] : woredasForZone(_zoneId!);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        KeyedSubtree(
          key: ValueKey(_regionId ?? 'none'),
          child: DropdownButtonFormField<String>(
            key: const ValueKey('ethio_address_region'),
            initialValue: _regionId,
            decoration: widget.regionDecoration ??
                const InputDecoration(labelText: 'Region'),
            isExpanded: true,
            items: regions
                .map(
                  (region) => DropdownMenuItem<String>(
                    value: region.id,
                    child: Text(region.name),
                  ),
                )
                .toList(growable: false),
            onChanged: (String? value) {
              setState(() {
                _regionId = value;
                _zoneId = null;
                _woredaId = null;
              });
              _emitChanged();
            },
          ),
        ),
        if (widget.level != EthioAddressPickerLevel.regionOnly) ...[
          const SizedBox(height: 12),
          KeyedSubtree(
            key: ValueKey('${_regionId ?? 'none'}:${_zoneId ?? 'none'}'),
            child: DropdownButtonFormField<String>(
              key: const ValueKey('ethio_address_zone'),
              initialValue: _zoneId,
              decoration: widget.zoneDecoration ??
                  const InputDecoration(labelText: 'Zone'),
              isExpanded: true,
              items: zones
                  .map(
                    (zone) => DropdownMenuItem<String>(
                      value: zone.id,
                      child: Text(zone.name),
                    ),
                  )
                  .toList(growable: false),
              onChanged: _regionId == null
                  ? null
                  : (String? value) {
                      setState(() {
                        _zoneId = value;
                        _woredaId = null;
                      });
                      _emitChanged();
                    },
            ),
          ),
        ],
        if (widget.level == EthioAddressPickerLevel.regionZoneWoreda) ...[
          const SizedBox(height: 12),
          KeyedSubtree(
            key: ValueKey('${_zoneId ?? 'none'}:${_woredaId ?? 'none'}'),
            child: DropdownButtonFormField<String>(
              key: const ValueKey('ethio_address_woreda'),
              initialValue: _woredaId,
              decoration: widget.woredaDecoration ??
                  const InputDecoration(labelText: 'Woreda'),
              isExpanded: true,
              items: woredas
                  .map(
                    (woreda) => DropdownMenuItem<String>(
                      value: woreda.id,
                      child: Text(woreda.name),
                    ),
                  )
                  .toList(growable: false),
              onChanged: _zoneId == null
                  ? null
                  : (String? value) {
                      setState(() {
                        _woredaId = value;
                      });
                      _emitChanged();
                    },
            ),
          ),
        ],
      ],
    );
  }
}
