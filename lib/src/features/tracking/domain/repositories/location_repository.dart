import 'package:dartz/dartz.dart';
import 'package:hajjmate/src/core/errors/failures.dart';
import 'package:hajjmate/src/features/tracking/domain/entities/location_update.dart';

abstract class LocationRepository {
  Future<Either<Failure, Unit>> publish(LocationUpdate update);
}
