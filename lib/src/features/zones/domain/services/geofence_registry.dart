import 'package:dartz/dartz.dart';
import 'package:hajjmate/src/core/errors/failures.dart';
import 'package:hajjmate/src/features/zones/domain/entities/zone.dart';

// Keeps the phone's operating system geofences in step with the zones.
abstract class GeofenceRegistry {
  // Returns how many geofences are registered. Fails with
  // [PermissionFailure] without "all the time" location access.
  Future<Either<Failure, int>> sync(List<Zone> zones);

  Future<Either<Failure, Unit>> clear();

  Future<bool> requestPermission();
}
