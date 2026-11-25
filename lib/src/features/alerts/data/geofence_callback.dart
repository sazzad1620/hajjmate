import 'package:flutter/foundation.dart';
import 'package:native_geofence/native_geofence.dart';

/// Runs when the phone enters or leaves a zone, even in the background.
/// The notification and the alert are added in the geofence alerts task.
@pragma('vm:entry-point')
Future<void> onGeofenceTriggered(GeofenceCallbackParams params) async {
  debugPrint(
    'Geofence ${params.event.name}: '
    '${params.geofences.map((geofence) => geofence.id).join(', ')}',
  );
}
