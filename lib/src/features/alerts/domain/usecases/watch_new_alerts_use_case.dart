import 'package:dartz/dartz.dart';
import 'package:hajjmate/src/core/errors/failures.dart';
import 'package:hajjmate/src/core/interfaces/stream_use_case.dart';
import 'package:hajjmate/src/features/alerts/domain/entities/alert.dart';
import 'package:hajjmate/src/features/alerts/domain/entities/watch_alerts_params.dart';
import 'package:hajjmate/src/features/alerts/domain/repositories/alert_repository.dart';

class WatchNewAlertsUseCase implements StreamUseCase<WatchAlertsParams, Alert> {
  final AlertRepository _repository;

  WatchNewAlertsUseCase(this._repository);

  @override
  Stream<Either<Failure, Alert>> execute(WatchAlertsParams params) =>
      _repository.watchNew(params.groupId);
}
