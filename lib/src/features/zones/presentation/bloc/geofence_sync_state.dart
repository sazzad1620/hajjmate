import 'package:equatable/equatable.dart';

enum GeofenceSyncStatus { syncing, active, permissionMissing, failure }

class GeofenceSyncState extends Equatable {
  final GeofenceSyncStatus status;

  final int registeredCount;
  final String? message;

  const GeofenceSyncState({
    this.status = GeofenceSyncStatus.syncing,
    this.registeredCount = 0,
    this.message,
  });

  @override
  List<Object?> get props => [status, registeredCount, message];
}
