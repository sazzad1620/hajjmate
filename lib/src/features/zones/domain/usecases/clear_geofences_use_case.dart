import 'package:dartz/dartz.dart';
import 'package:hajjmate/src/core/errors/failures.dart';
import 'package:hajjmate/src/core/interfaces/use_case.dart';
import 'package:hajjmate/src/features/zones/domain/services/geofence_context_store.dart';
import 'package:hajjmate/src/features/zones/domain/services/geofence_registry.dart';
import 'package:hajjmate/src/shared/models/no_params.dart';

class ClearGeofencesUseCase implements UseCase<NoParams, Unit> {
  final GeofenceRegistry _registry;
  final GeofenceContextStore _contextStore;

  ClearGeofencesUseCase(this._registry, this._contextStore);

  @override
  Future<Either<Failure, Unit>> execute(NoParams input) async {
    try {
      await _contextStore.clear();
    } catch (_) {
      return const Left(UnknownFailure());
    }
    return _registry.clear();
  }
}
