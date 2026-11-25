import 'package:dartz/dartz.dart';
import 'package:hajjmate/src/core/errors/failures.dart';
import 'package:hajjmate/src/core/interfaces/use_case.dart';
import 'package:hajjmate/src/features/alerts/domain/entities/watch_alerts_params.dart';
import 'package:hajjmate/src/features/alerts/domain/services/alert_monitor_service.dart';

class StartAlertMonitoringUseCase implements UseCase<WatchAlertsParams, Unit> {
  final AlertMonitorService _service;

  StartAlertMonitoringUseCase(this._service);

  @override
  Future<Either<Failure, Unit>> execute(WatchAlertsParams params) async {
    // A plugin error must become a failure, not an uncaught exception.
    try {
      final started = await _service.start(groupId: params.groupId);
      return started ? const Right(unit) : const Left(UnknownFailure());
    } catch (_) {
      return const Left(UnknownFailure());
    }
  }
}
