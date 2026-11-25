import 'package:dartz/dartz.dart';
import 'package:hajjmate/src/core/errors/failures.dart';
import 'package:hajjmate/src/features/zones/domain/entities/zone.dart';

abstract class ZoneRepository {
  // Every zone of the group, emitted again on each change.
  Stream<Either<Failure, List<Zone>>> watchZones(String groupId);

  Future<Either<Failure, int>> countZones(String groupId);

  // The storage gives the new zone its id, so [Zone.id] is ignored.
  Future<Either<Failure, Unit>> createZone(Zone zone);

  // Saves the name and radius; the centre stays as it was.
  Future<Either<Failure, Unit>> updateZone(Zone zone);

  Future<Either<Failure, Unit>> deleteZone(String zoneId);
}
