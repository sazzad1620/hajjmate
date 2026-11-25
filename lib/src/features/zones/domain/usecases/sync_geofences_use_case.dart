import 'package:dartz/dartz.dart';
import 'package:hajjmate/src/core/errors/failures.dart';
import 'package:hajjmate/src/core/interfaces/use_case.dart';
import 'package:hajjmate/src/features/zones/domain/entities/geofence_context.dart';
import 'package:hajjmate/src/features/zones/domain/entities/sync_geofences_params.dart';
import 'package:hajjmate/src/features/zones/domain/services/geofence_context_store.dart';
import 'package:hajjmate/src/features/zones/domain/services/geofence_registry.dart';

class SyncGeofencesUseCase implements UseCase<SyncGeofencesParams, int> {
  final GeofenceRegistry _registry;
  final GeofenceContextStore _contextStore;

  SyncGeofencesUseCase(this._registry, this._contextStore);

  @override
  Future<Either<Failure, int>> execute(SyncGeofencesParams params) async {
    // Saved first, so a geofence can never fire without its context.
    try {
      await _contextStore.save(
        GeofenceContext(
          userId: params.userId,
          userName: params.userName,
          groupId: params.groupId,
          zoneNames: {for (final zone in params.zones) zone.id: zone.name},
        ),
      );
    } catch (_) {
      return const Left(UnknownFailure());
    }
    return _registry.sync(params.zones);
  }
}
