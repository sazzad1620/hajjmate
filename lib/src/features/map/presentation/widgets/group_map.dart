import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:hajjmate/src/core/constants/app_constants.dart';
import 'package:hajjmate/src/features/map/presentation/widgets/member_marker.dart';
import 'package:hajjmate/src/features/map/presentation/widgets/member_sheet.dart';
import 'package:hajjmate/src/features/tracking/domain/entities/location_update.dart';
import 'package:hajjmate/src/features/zones/domain/entities/zone.dart';
import 'package:hajjmate/src/features/zones/presentation/widgets/zone_layers.dart';
import 'package:hajjmate/src/shared/widgets/map/osm_tile_layer.dart';
import 'package:latlong2/latlong.dart';

class GroupMap extends StatefulWidget {
  final List<LocationUpdate> members;
  final List<Zone> zones;

  const GroupMap({super.key, this.members = const [], this.zones = const []});

  @override
  State<GroupMap> createState() => _GroupMapState();
}

class _GroupMapState extends State<GroupMap> {
  static const LatLng _fallbackCenter = LatLng(21.4225, 39.8262);
  static const double _fallbackZoom = 12;

  final MapController _controller = MapController();
  Timer? _staleCheck;
  bool _mapReady = false;
  bool _fitted = false;

  @override
  void initState() {
    super.initState();
    // Repaints so pins turn grey even when no new location arrives.
    _staleCheck = Timer.periodic(
      AppConstants.locationUpdateInterval,
      (_) => setState(() {}),
    );
  }

  @override
  void didUpdateWidget(GroupMap oldWidget) {
    super.didUpdateWidget(oldWidget);
    _fitOnce();
  }

  @override
  void dispose() {
    _staleCheck?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _fitOnce() {
    final points = [
      for (final member in widget.members) _pointOf(member),
      for (final zone in widget.zones)
        LatLng(zone.centre.latitude, zone.centre.longitude),
    ];
    if (!_mapReady || _fitted || points.isEmpty) return;
    _fitted = true;
    _controller.fitCamera(
      CameraFit.coordinates(
        coordinates: points,
        padding: const EdgeInsets.all(72),
        maxZoom: 16,
      ),
    );
  }

  LatLng _pointOf(LocationUpdate member) =>
      LatLng(member.position.latitude, member.position.longitude);

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    return FlutterMap(
      mapController: _controller,
      options: MapOptions(
        initialCenter: _fallbackCenter,
        initialZoom: _fallbackZoom,
        onMapReady: () {
          _mapReady = true;
          _fitOnce();
        },
      ),
      children: [
        OsmTileLayer(),
        ...zoneLayers(context, widget.zones),
        MarkerLayer(
          markers: [
            for (final member in widget.members)
              Marker(
                point: _pointOf(member),
                width: 120,
                height: 68,
                alignment: Alignment.topCenter,
                child: MemberMarker(
                  name: member.name,
                  isStale:
                      now.difference(member.timestamp) >
                      AppConstants.staleLocationAfter,
                  onTap: () => MemberSheet.show(context, member),
                ),
              ),
          ],
        ),
        const RichAttributionWidget(
          attributions: [TextSourceAttribution('OpenStreetMap contributors')],
        ),
      ],
    );
  }
}
