import 'package:dartz/dartz.dart';
import 'package:hajjmate/src/core/errors/failures.dart';
import 'package:hajjmate/src/core/interfaces/use_case.dart';
import 'package:hajjmate/src/features/zones/domain/entities/delete_zone_params.dart';
import 'package:hajjmate/src/features/zones/domain/repositories/zone_repository.dart';

class DeleteZoneUseCase implements UseCase<DeleteZoneParams, Unit> {
  final ZoneRepository _repository;

  DeleteZoneUseCase(this._repository);

  @override
  Future<Either<Failure, Unit>> execute(DeleteZoneParams params) =>
      _repository.deleteZone(params.zoneId);
}
