import 'package:dartz/dartz.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:hajjmate/src/core/errors/error_handler.dart';
import 'package:hajjmate/src/core/errors/failures.dart';
import 'package:hajjmate/src/features/tracking/data/models/location_update_model.dart';
import 'package:hajjmate/src/features/tracking/domain/entities/location_update.dart';
import 'package:hajjmate/src/features/tracking/domain/repositories/location_repository.dart';

class RealtimeLocationRepository implements LocationRepository {
  static const Duration _writeTimeout = Duration(seconds: 10);

  final FirebaseDatabase _database;
  final ErrorHandler _errorHandler;

  RealtimeLocationRepository(this._database, this._errorHandler);

  @override
  Future<Either<Failure, Unit>> publish(LocationUpdate update) async {
    try {
      await _database
          .ref('locations/${update.groupId}/${update.userId}')
          .set(LocationUpdateModel(update).toMap())
          .timeout(_writeTimeout);
      return const Right(unit);
    } catch (e) {
      return Left(_errorHandler.handle(e));
    }
  }
}
