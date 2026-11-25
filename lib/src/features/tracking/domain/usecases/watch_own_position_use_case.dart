import 'package:dartz/dartz.dart';
import 'package:hajjmate/src/core/errors/failures.dart';
import 'package:hajjmate/src/core/interfaces/stream_use_case.dart';
import 'package:hajjmate/src/features/tracking/domain/services/device_location_provider.dart';
import 'package:hajjmate/src/shared/models/coordinates.dart';
import 'package:hajjmate/src/shared/models/no_params.dart';

class WatchOwnPositionUseCase implements StreamUseCase<NoParams, Coordinates> {
  final DeviceLocationProvider _provider;

  WatchOwnPositionUseCase(this._provider);

  @override
  Stream<Either<Failure, Coordinates>> execute(NoParams params) async* {
    // The stream throws when location is off or not allowed.
    try {
      await for (final position in _provider.watchPosition()) {
        yield Right(position);
      }
    } catch (_) {
      yield const Left(
        PermissionFailure(message: 'Allow location to see yourself.'),
      );
    }
  }
}
