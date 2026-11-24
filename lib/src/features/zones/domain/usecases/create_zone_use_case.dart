import 'package:dartz/dartz.dart';
import 'package:hajjmate/src/core/constants/app_constants.dart';
import 'package:hajjmate/src/core/errors/failures.dart';
import 'package:hajjmate/src/core/interfaces/use_case.dart';
import 'package:hajjmate/src/features/zones/domain/entities/create_zone_params.dart';
import 'package:hajjmate/src/features/zones/domain/entities/zone.dart';
import 'package:hajjmate/src/features/zones/domain/repositories/zone_repository.dart';

class CreateZoneUseCase implements UseCase<CreateZoneParams, Unit> {
  final ZoneRepository _repository;

  CreateZoneUseCase(this._repository);

  @override
  Future<Either<Failure, Unit>> execute(CreateZoneParams params) async {
    final Zone zone;
    try {
      zone = Zone(
        id: '',
        groupId: params.groupId,
        name: params.name.trim(),
        centre: params.centre,
        radiusM: params.radiusM,
      );
    } on ArgumentError catch (e) {
      return Left(ValidationFailure(message: e.message.toString()));
    }

    final countResult = await _repository.countZones(params.groupId);
    return countResult.fold((failure) async => Left(failure), (count) async {
      if (count >= AppConstants.maxZonesPerGroup) {
        return const Left(
          ValidationFailure(
            message:
                'You can add up to ${AppConstants.maxZonesPerGroup} zones.',
          ),
        );
      }
      return _repository.createZone(zone);
    });
  }
}
