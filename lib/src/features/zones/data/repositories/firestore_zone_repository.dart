import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:hajjmate/src/core/errors/error_handler.dart';
import 'package:hajjmate/src/core/errors/failures.dart';
import 'package:hajjmate/src/features/zones/data/models/zone_model.dart';
import 'package:hajjmate/src/features/zones/domain/entities/zone.dart';
import 'package:hajjmate/src/features/zones/domain/repositories/zone_repository.dart';

class FirestoreZoneRepository implements ZoneRepository {
  // Offline, a Firestore write never completes, so give up after a while.
  static const Duration _timeout = Duration(seconds: 10);

  final FirebaseFirestore _firestore;
  final ErrorHandler _errorHandler;

  FirestoreZoneRepository(this._firestore, this._errorHandler);

  CollectionReference<Map<String, dynamic>> get _zones =>
      _firestore.collection('zones');

  @override
  Stream<Either<Failure, List<Zone>>> watchZones(String groupId) async* {
    try {
      final snapshots = _zones.where('groupId', isEqualTo: groupId).snapshots();
      await for (final snapshot in snapshots) {
        final zones = [
          for (final doc in snapshot.docs)
            ZoneModel.fromMap(id: doc.id, map: doc.data()).zone,
        ]..sort((a, b) => a.name.compareTo(b.name));
        yield Right(zones);
      }
    } catch (e) {
      yield Left(_errorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, int>> countZones(String groupId) async {
    try {
      final snapshot = await _zones
          .where('groupId', isEqualTo: groupId)
          .count()
          .get()
          .timeout(_timeout);
      return Right(snapshot.count ?? 0);
    } catch (e) {
      return Left(_errorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, Unit>> createZone(Zone zone) async {
    try {
      await _zones
          .add({
            ...ZoneModel(zone).toMap(),
            'createdAt': FieldValue.serverTimestamp(),
          })
          .timeout(_timeout);
      return const Right(unit);
    } catch (e) {
      return Left(_errorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, Unit>> updateZone(Zone zone) async {
    try {
      await _zones
          .doc(zone.id)
          .update({'name': zone.name, 'radiusM': zone.radiusM})
          .timeout(_timeout);
      return const Right(unit);
    } catch (e) {
      return Left(_errorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteZone(String zoneId) async {
    try {
      await _zones.doc(zoneId).delete().timeout(_timeout);
      return const Right(unit);
    } catch (e) {
      return Left(_errorHandler.handle(e));
    }
  }
}
