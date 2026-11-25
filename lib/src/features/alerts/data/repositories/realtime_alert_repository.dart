import 'package:dartz/dartz.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:hajjmate/src/core/errors/error_handler.dart';
import 'package:hajjmate/src/core/errors/failures.dart';
import 'package:hajjmate/src/features/alerts/data/models/alert_model.dart';
import 'package:hajjmate/src/features/alerts/domain/entities/alert.dart';
import 'package:hajjmate/src/features/alerts/domain/repositories/alert_repository.dart';

class RealtimeAlertRepository implements AlertRepository {
  // The geofence callback must stay short, so give up on a bad connection.
  static const Duration _writeTimeout = Duration(seconds: 10);

  final FirebaseDatabase _database;
  final ErrorHandler _errorHandler;

  RealtimeAlertRepository(this._database, this._errorHandler);

  @override
  Future<Either<Failure, Unit>> publish(Alert alert) async {
    try {
      await _database
          .ref('alerts/${alert.groupId}')
          .push()
          .set(AlertModel(alert).toMap())
          .timeout(_writeTimeout);
      return const Right(unit);
    } catch (e) {
      return Left(_errorHandler.handle(e));
    }
  }
}
