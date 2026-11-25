import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/widgets.dart';
import 'package:hajjmate/firebase_options.dart';
import 'package:hajjmate/src/core/errors/error_handler.dart';
import 'package:hajjmate/src/features/alerts/data/repositories/realtime_alert_repository.dart';
import 'package:hajjmate/src/features/alerts/data/services/local_notifier.dart';
import 'package:hajjmate/src/features/alerts/domain/entities/alert.dart';
import 'package:hajjmate/src/features/alerts/domain/entities/alert_type.dart';
import 'package:hajjmate/src/features/alerts/domain/usecases/report_zone_event_use_case.dart';
import 'package:hajjmate/src/features/zones/data/services/shared_preferences_geofence_context_store.dart';
import 'package:hajjmate/src/shared/models/coordinates.dart';
import 'package:native_geofence/native_geofence.dart';

// Runs when the phone enters or leaves a zone, even in the background.
// It has its own isolate, where `get_it` is not set up, so it builds the few
// objects it needs itself.
@pragma('vm:entry-point')
Future<void> onGeofenceTriggered(GeofenceCallbackParams params) async {
  final AlertType type;
  switch (params.event) {
    case GeofenceEvent.enter:
      type = AlertType.enter;
    case GeofenceEvent.exit:
      type = AlertType.exit;
    default:
      return;
  }

  WidgetsFlutterBinding.ensureInitialized();
  final context = await SharedPreferencesGeofenceContextStore().load();
  if (context == null) return;

  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
  final reportZoneEvent = ReportZoneEventUseCase(
    RealtimeAlertRepository(FirebaseDatabase.instance, ErrorHandler()),
    LocalNotifier(),
  );

  for (final geofence in params.geofences) {
    // The phone does not always report where the event happened.
    final place = params.location ?? geofence.location;
    await reportZoneEvent.execute(
      Alert(
        type: type,
        groupId: context.groupId,
        userId: context.userId,
        userName: context.userName,
        zoneId: geofence.id,
        zoneName: context.zoneNames[geofence.id] ?? 'a zone',
        position: Coordinates(
          latitude: place.latitude,
          longitude: place.longitude,
        ),
        timestamp: params.triggeredAt ?? DateTime.now(),
      ),
    );
  }
}
