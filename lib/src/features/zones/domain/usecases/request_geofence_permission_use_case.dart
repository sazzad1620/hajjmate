import 'package:dartz/dartz.dart';
import 'package:hajjmate/src/core/errors/failures.dart';
import 'package:hajjmate/src/core/interfaces/use_case.dart';
import 'package:hajjmate/src/features/zones/domain/services/geofence_registry.dart';
import 'package:hajjmate/src/shared/models/no_params.dart';

class RequestGeofencePermissionUseCase implements UseCase<NoParams, bool> {
  final GeofenceRegistry _registry;

  RequestGeofencePermissionUseCase(this._registry);

  @override
  Future<Either<Failure, bool>> execute(NoParams input) async {
    try {
      return Right(await _registry.requestPermission());
    } catch (_) {
      return const Left(UnknownFailure());
    }
  }
}
