import 'package:dartz/dartz.dart';
import 'package:hajjmate/src/core/errors/failures.dart';
import 'package:hajjmate/src/features/alerts/domain/entities/alert.dart';

abstract class AlertRepository {
  /// Adds the alert to the group's list. Alerts are never overwritten.
  Future<Either<Failure, Unit>> publish(Alert alert);
}
