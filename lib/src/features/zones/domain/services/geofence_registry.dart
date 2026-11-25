import 'package:dartz/dartz.dart';
import 'package:hajjmate/src/core/errors/failures.dart';
import 'package:hajjmate/src/features/zones/domain/entities/zone.dart';

/// Keeps the phone's operating system geofences in step with the zones.
abstract class GeofenceRegistry {
  /// Makes the registered geofences match [zones] and returns how many are
  /// registered. Fails with [PermissionFailure] without "all the time"
  /// location access.
  Future<Either<Failure, int>> sync(List<Zone> zones);

  /// Removes every registered geofence.
  Future<Either<Failure, Unit>> clear();

  /// Asks for "all the time" location access; true when it is granted.
  Future<bool> requestPermission();
}
