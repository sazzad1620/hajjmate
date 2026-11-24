import 'package:dartz/dartz.dart';
import 'package:hajjmate/src/core/errors/failures.dart';
import 'package:hajjmate/src/core/interfaces/use_case.dart';
import 'package:hajjmate/src/features/tracking/domain/services/location_sharing_service.dart';
import 'package:hajjmate/src/shared/models/no_params.dart';

class GetSharingStatusUseCase implements UseCase<NoParams, bool> {
  final LocationSharingService _sharingService;

  GetSharingStatusUseCase(this._sharingService);

  @override
  Future<Either<Failure, bool>> execute(NoParams params) async {
    return Right(await _sharingService.isRunning());
  }
}
