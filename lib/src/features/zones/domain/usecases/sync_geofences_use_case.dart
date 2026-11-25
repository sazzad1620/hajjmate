import 'package:dartz/dartz.dart';
import 'package:hajjmate/src/core/errors/failures.dart';
import 'package:hajjmate/src/core/interfaces/use_case.dart';
import 'package:hajjmate/src/features/zones/domain/entities/zone.dart';
import 'package:hajjmate/src/features/zones/domain/services/geofence_registry.dart';

class SyncGeofencesUseCase implements UseCase<List<Zone>, int> {
  final GeofenceRegistry _registry;

  SyncGeofencesUseCase(this._registry);

  @override
  Future<Either<Failure, int>> execute(List<Zone> zones) =>
      _registry.sync(zones);
}
