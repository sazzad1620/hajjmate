import 'package:dartz/dartz.dart';
import 'package:hajjmate/src/core/errors/failures.dart';
import 'package:hajjmate/src/core/interfaces/use_case.dart';
import 'package:hajjmate/src/features/alerts/domain/entities/alert.dart';
import 'package:hajjmate/src/features/alerts/domain/entities/alert_type.dart';
import 'package:hajjmate/src/features/alerts/domain/repositories/alert_repository.dart';
import 'package:hajjmate/src/features/alerts/domain/services/notifier.dart';

class ReportZoneEventUseCase implements UseCase<Alert, Unit> {
  final AlertRepository _repository;
  final Notifier _notifier;

  ReportZoneEventUseCase(this._repository, this._notifier);

  @override
  Future<Either<Failure, Unit>> execute(Alert alert) async {
    // The notification comes first: it is local, so it works without internet
    // and a failed upload cannot hide it.
    try {
      final action = alert.type == AlertType.enter ? 'entered' : 'left';
      await _notifier.show(
        title: 'Zone alert',
        body: 'You $action ${alert.zoneName}',
      );
    } catch (_) {}
    return _repository.publish(alert);
  }
}
