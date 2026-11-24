import 'package:dartz/dartz.dart';
import 'package:hajjmate/src/core/errors/failures.dart';
import 'package:hajjmate/src/core/interfaces/use_case.dart';
import 'package:hajjmate/src/features/tracking/domain/services/location_sharing_service.dart';
import 'package:hajjmate/src/shared/models/no_params.dart';

class StopLocationSharingUseCase implements UseCase<NoParams, Unit> {
  final LocationSharingService _sharingService;

  StopLocationSharingUseCase(this._sharingService);

  @override
  Future<Either<Failure, Unit>> execute(NoParams params) async {
    await _sharingService.stop();
    return const Right(unit);
  }
}
