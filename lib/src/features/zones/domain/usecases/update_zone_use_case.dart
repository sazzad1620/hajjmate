import 'package:dartz/dartz.dart';
import 'package:hajjmate/src/core/errors/failures.dart';
import 'package:hajjmate/src/core/interfaces/use_case.dart';
import 'package:hajjmate/src/features/zones/domain/entities/update_zone_params.dart';
import 'package:hajjmate/src/features/zones/domain/entities/zone.dart';
import 'package:hajjmate/src/features/zones/domain/repositories/zone_repository.dart';

class UpdateZoneUseCase implements UseCase<UpdateZoneParams, Unit> {
  final ZoneRepository _repository;

  UpdateZoneUseCase(this._repository);

  @override
  Future<Either<Failure, Unit>> execute(UpdateZoneParams params) {
    final Zone zone;
    try {
      zone = Zone(
        id: params.zone.id,
        groupId: params.zone.groupId,
        name: params.name.trim(),
        centre: params.zone.centre,
        radiusM: params.radiusM,
      );
    } on ArgumentError catch (e) {
      return Future.value(
        Left(ValidationFailure(message: e.message.toString())),
      );
    }
    return _repository.updateZone(zone);
  }
}
