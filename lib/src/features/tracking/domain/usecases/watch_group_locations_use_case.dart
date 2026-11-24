import 'package:dartz/dartz.dart';
import 'package:hajjmate/src/core/errors/failures.dart';
import 'package:hajjmate/src/core/interfaces/stream_use_case.dart';
import 'package:hajjmate/src/features/tracking/domain/entities/location_update.dart';
import 'package:hajjmate/src/features/tracking/domain/entities/watch_group_params.dart';
import 'package:hajjmate/src/features/tracking/domain/repositories/location_repository.dart';

class WatchGroupLocationsUseCase
    implements StreamUseCase<WatchGroupParams, List<LocationUpdate>> {
  final LocationRepository _repository;

  WatchGroupLocationsUseCase(this._repository);

  @override
  Stream<Either<Failure, List<LocationUpdate>>> execute(
    WatchGroupParams params,
  ) => _repository.watchGroup(params.groupId);
}
