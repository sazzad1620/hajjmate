import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hajjmate/src/features/map/presentation/widgets/group_map.dart';
import 'package:hajjmate/src/features/zones/presentation/bloc/geofence_sync_bloc.dart';
import 'package:hajjmate/src/features/zones/presentation/bloc/geofence_sync_state.dart';
import 'package:hajjmate/src/features/zones/presentation/bloc/zone_list_bloc.dart';
import 'package:hajjmate/src/features/zones/presentation/bloc/zone_list_state.dart';

/// The Hajji sees the zones only, not where the other Hajjis are.
class ScreenHajjiMap extends StatelessWidget {
  const ScreenHajjiMap({super.key});

  String _summary(ZoneListState state, GeofenceSyncState alerts) {
    return switch (state.status) {
      ZoneListStatus.loading => 'Loading...',
      ZoneListStatus.failure => state.message ?? 'Could not load the map.',
      ZoneListStatus.ready =>
        state.zones.isEmpty
            ? 'No zones yet'
            : '${state.zones.length} zones, ${_alerts(alerts)}',
    };
  }

  String _alerts(GeofenceSyncState alerts) {
    return switch (alerts.status) {
      GeofenceSyncStatus.active => 'alerts on for ${alerts.registeredCount}',
      GeofenceSyncStatus.permissionMissing => 'alerts off',
      GeofenceSyncStatus.syncing => 'alerts starting',
      GeofenceSyncStatus.failure => 'alerts failed',
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<ZoneListBloc, ZoneListState>(
        builder: (context, state) {
          return Stack(
            children: [
              GroupMap(zones: state.zones),
              SafeArea(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        child: BlocBuilder<GeofenceSyncBloc, GeofenceSyncState>(
                          builder: (context, alerts) => Text(
                            _summary(state, alerts),
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
