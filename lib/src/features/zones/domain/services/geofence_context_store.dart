import 'package:hajjmate/src/features/zones/domain/entities/geofence_context.dart';

abstract class GeofenceContextStore {
  Future<void> save(GeofenceContext context);

  /// Null when nothing was saved, for example after signing out.
  Future<GeofenceContext?> load();

  Future<void> clear();
}
