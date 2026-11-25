import 'package:dartz/dartz.dart';
import 'package:hajjmate/src/core/errors/failures.dart';
import 'package:hajjmate/src/core/interfaces/use_case.dart';
import 'package:hajjmate/src/features/alerts/domain/services/alert_monitor_service.dart';
import 'package:hajjmate/src/shared/models/no_params.dart';

class StopAlertMonitoringUseCase implements UseCase<NoParams, Unit> {
  final AlertMonitorService _service;

  StopAlertMonitoringUseCase(this._service);

  @override
  Future<Either<Failure, Unit>> execute(NoParams params) async {
    try {
      await _service.stop();
    } catch (_) {
      return const Left(UnknownFailure());
    }
    return const Right(unit);
  }
}
