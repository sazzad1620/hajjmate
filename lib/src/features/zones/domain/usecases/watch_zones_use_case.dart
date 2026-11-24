import 'package:dartz/dartz.dart';
import 'package:hajjmate/src/core/errors/failures.dart';
import 'package:hajjmate/src/core/interfaces/stream_use_case.dart';
import 'package:hajjmate/src/features/zones/domain/entities/watch_zones_params.dart';
import 'package:hajjmate/src/features/zones/domain/entities/zone.dart';
import 'package:hajjmate/src/features/zones/domain/repositories/zone_repository.dart';

class WatchZonesUseCase implements StreamUseCase<WatchZonesParams, List<Zone>> {
  final ZoneRepository _repository;

  WatchZonesUseCase(this._repository);

  @override
  Stream<Either<Failure, List<Zone>>> execute(WatchZonesParams params) =>
      _repository.watchZones(params.groupId);
}
