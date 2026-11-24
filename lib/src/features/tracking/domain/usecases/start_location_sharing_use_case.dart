import 'package:dartz/dartz.dart';
import 'package:hajjmate/src/core/errors/failures.dart';
import 'package:hajjmate/src/core/interfaces/use_case.dart';
import 'package:hajjmate/src/features/tracking/domain/entities/start_sharing_params.dart';
import 'package:hajjmate/src/features/tracking/domain/services/device_location_provider.dart';
import 'package:hajjmate/src/features/tracking/domain/services/location_sharing_service.dart';

class StartLocationSharingUseCase implements UseCase<StartSharingParams, Unit> {
  final DeviceLocationProvider _locationProvider;
  final LocationSharingService _sharingService;

  StartLocationSharingUseCase(this._locationProvider, this._sharingService);

  @override
  Future<Either<Failure, Unit>> execute(StartSharingParams params) async {
    // A plugin error must become a failure, or the screen would wait forever.
    try {
      final allowed = await _locationProvider.requestPermissions();
      if (!allowed) {
        return const Left(
          PermissionFailure(message: 'Allow location to share your position.'),
        );
      }

      final started = await _sharingService.start(
        userId: params.userId,
        name: params.name,
        groupId: params.groupId,
      );
      return started ? const Right(unit) : const Left(UnknownFailure());
    } catch (_) {
      return const Left(UnknownFailure());
    }
  }
}
