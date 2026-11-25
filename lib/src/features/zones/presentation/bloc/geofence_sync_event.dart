import 'package:equatable/equatable.dart';

abstract class GeofenceSyncEvent extends Equatable {
  const GeofenceSyncEvent();

  @override
  List<Object?> get props => [];
}

class GeofenceSyncStarted extends GeofenceSyncEvent {
  const GeofenceSyncStarted();
}

class GeofenceSyncRequested extends GeofenceSyncEvent {
  const GeofenceSyncRequested();
}

class GeofencePermissionRequested extends GeofenceSyncEvent {
  const GeofencePermissionRequested();
}
