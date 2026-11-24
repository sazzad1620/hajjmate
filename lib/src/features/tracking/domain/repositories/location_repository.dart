import 'package:dartz/dartz.dart';
import 'package:hajjmate/src/core/errors/failures.dart';
import 'package:hajjmate/src/features/tracking/domain/entities/location_update.dart';

abstract class LocationRepository {
  Future<Either<Failure, Unit>> publish(LocationUpdate update);

  /// The latest location of every member, emitted again on each change.
  Stream<Either<Failure, List<LocationUpdate>>> watchGroup(String groupId);
}
