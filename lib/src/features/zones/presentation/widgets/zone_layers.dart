import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:hajjmate/src/features/zones/domain/entities/zone.dart';
import 'package:latlong2/latlong.dart';

/// The map layers that draw [zones]: a circle for each and its name.
List<Widget> zoneLayers(BuildContext context, List<Zone> zones) {
  if (zones.isEmpty) return const [];
  final colors = Theme.of(context).colorScheme;

  return [
    CircleLayer(
      circles: [
        for (final zone in zones)
          CircleMarker(
            point: LatLng(zone.centre.latitude, zone.centre.longitude),
            radius: zone.radiusM,
            useRadiusInMeter: true,
            color: colors.primary.withValues(alpha: 0.15),
            borderColor: colors.primary,
            borderStrokeWidth: 2,
          ),
      ],
    ),
    MarkerLayer(
      markers: [
        for (final zone in zones)
          Marker(
            point: LatLng(zone.centre.latitude, zone.centre.longitude),
            width: 140,
            height: 28,
            child: Center(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: colors.surface.withValues(alpha: 0.85),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  child: Text(
                    zone.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ),
              ),
            ),
          ),
      ],
    ),
  ];
}
