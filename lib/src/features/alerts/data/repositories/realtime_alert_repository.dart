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

  static const int _listSize = 50;

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

  @override
  Stream<Either<Failure, List<Alert>>> watchLatest(String groupId) async* {
    try {
      final query = _database.ref('alerts/$groupId').limitToLast(_listSize);
      await for (final event in query.onValue) {
        yield Right([
          for (final child in event.snapshot.children.toList().reversed)
            _alertOf(groupId, child),
        ]);
      }
    } catch (e) {
      yield Left(_errorHandler.handle(e));
    }
  }

  @override
  Stream<Either<Failure, Alert>> watchNew(String groupId) async* {
    try {
      final ref = _database.ref('alerts/$groupId');
      // Push keys grow with time, so "after the last key" means "new", and it
      // does not depend on the phones' clocks.
      final last = await ref.limitToLast(1).get();
      final lastKey = last.children.isEmpty ? null : last.children.first.key;
      final query = lastKey == null
          ? ref.orderByKey()
          : ref.orderByKey().startAfter(lastKey);
      await for (final event in query.onChildAdded) {
        yield Right(_alertOf(groupId, event.snapshot));
      }
    } catch (e) {
      yield Left(_errorHandler.handle(e));
    }
  }

  Alert _alertOf(String groupId, DataSnapshot snapshot) {
    return AlertModel.fromMap(
      groupId: groupId,
      map: snapshot.value! as Map<Object?, Object?>,
    ).alert;
  }
}
