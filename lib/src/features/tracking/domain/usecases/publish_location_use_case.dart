import 'package:dartz/dartz.dart';
import 'package:hajjmate/src/core/errors/failures.dart';
import 'package:hajjmate/src/core/interfaces/use_case.dart';
import 'package:hajjmate/src/features/tracking/domain/entities/location_update.dart';
import 'package:hajjmate/src/features/tracking/domain/repositories/location_repository.dart';

class PublishLocationUseCase implements UseCase<LocationUpdate, Unit> {
  final LocationRepository _repository;

  PublishLocationUseCase(this._repository);

  @override
  Future<Either<Failure, Unit>> execute(LocationUpdate update) =>
      _repository.publish(update);
}
