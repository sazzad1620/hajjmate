import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hajjmate/src/features/zones/presentation/bloc/geofence_sync_bloc.dart';
import 'package:hajjmate/src/features/zones/presentation/bloc/geofence_sync_event.dart';
import 'package:hajjmate/src/features/zones/presentation/bloc/geofence_sync_state.dart';
import 'package:hajjmate/src/shared/widgets/buttons/base_button.dart';

class GeofencePermissionBanner extends StatefulWidget {
  const GeofencePermissionBanner({super.key});

  @override
  State<GeofencePermissionBanner> createState() =>
      _GeofencePermissionBannerState();
}

class _GeofencePermissionBannerState extends State<GeofencePermissionBanner>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // The permission is granted in the phone's settings, so check again when
  // the Hajji comes back to the app.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final bloc = context.read<GeofenceSyncBloc>();
    if (state == AppLifecycleState.resumed &&
        bloc.state.status == GeofenceSyncStatus.permissionMissing) {
      bloc.add(const GeofenceSyncRequested());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GeofenceSyncBloc, GeofenceSyncState>(
      buildWhen: (before, after) => before.status != after.status,
      builder: (context, state) {
        if (state.status != GeofenceSyncStatus.permissionMissing) {
          return const SizedBox.shrink();
        }
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Card(
            margin: EdgeInsets.zero,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Allow location all the time so zone alerts work.',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 12),
                  BaseButton(
                    label: 'Allow',
                    isPrimary: false,
                    onPressed: () => context.read<GeofenceSyncBloc>().add(
                      const GeofencePermissionRequested(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
