import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hajjmate/src/core/errors/failures.dart';
import 'package:hajjmate/src/features/auth/domain/usecases/get_current_user_use_case.dart';
import 'package:hajjmate/src/features/zones/domain/entities/watch_zones_params.dart';
import 'package:hajjmate/src/features/zones/domain/entities/zone.dart';
import 'package:hajjmate/src/features/zones/domain/usecases/clear_geofences_use_case.dart';
import 'package:hajjmate/src/features/zones/domain/usecases/request_geofence_permission_use_case.dart';
import 'package:hajjmate/src/features/zones/domain/usecases/sync_geofences_use_case.dart';
import 'package:hajjmate/src/features/zones/domain/usecases/watch_zones_use_case.dart';
import 'package:hajjmate/src/features/zones/presentation/bloc/geofence_sync_event.dart';
import 'package:hajjmate/src/features/zones/presentation/bloc/geofence_sync_state.dart';
import 'package:hajjmate/src/shared/models/no_params.dart';

/// Keeps the Hajji's phone geofences equal to the group's zones.
class GeofenceSyncBloc extends Bloc<GeofenceSyncEvent, GeofenceSyncState> {
  final GetCurrentUserUseCase _getCurrentUser;
  final WatchZonesUseCase _watchZones;
  final SyncGeofencesUseCase _sync;
  final ClearGeofencesUseCase _clear;
  final RequestGeofencePermissionUseCase _requestPermission;

  List<Zone> _zones = const [];

  GeofenceSyncBloc(
    this._getCurrentUser,
    this._watchZones,
    this._sync,
    this._clear,
    this._requestPermission,
  ) : super(const GeofenceSyncState()) {
    on<GeofenceSyncStarted>(_onStarted);
    on<GeofenceSyncRequested>((event, emit) => _syncNow(emit));
    on<GeofencePermissionRequested>(_onPermissionRequested);
  }

  Future<void> _onStarted(
    GeofenceSyncStarted event,
    Emitter<GeofenceSyncState> emit,
  ) async {
    final userResult = await _getCurrentUser.execute(const NoParams());
    final user = userResult.fold((_) => null, (user) => user);
    if (user == null) {
      emit(
        const GeofenceSyncState(
          status: GeofenceSyncStatus.failure,
          message: 'Could not load your profile. Sign in again.',
        ),
      );
      return;
    }

    await for (final result in _watchZones.execute(
      WatchZonesParams(groupId: user.groupId),
    )) {
      if (emit.isDone) return;
      final zones = result.fold((_) => null, (zones) => zones);
      if (zones == null) {
        emit(
          GeofenceSyncState(
            status: GeofenceSyncStatus.failure,
            registeredCount: state.registeredCount,
            message: result.fold((failure) => failure.message, (_) => null),
          ),
        );
        continue;
      }
      _zones = zones;
      await _syncNow(emit);
    }
  }

  Future<void> _onPermissionRequested(
    GeofencePermissionRequested event,
    Emitter<GeofenceSyncState> emit,
  ) async {
    await _requestPermission.execute(const NoParams());
    await _syncNow(emit);
  }

  Future<void> _syncNow(Emitter<GeofenceSyncState> emit) async {
    final result = await _sync.execute(_zones);
    if (emit.isDone) return;
    emit(
      result.fold(
        (failure) => GeofenceSyncState(
          status: failure is PermissionFailure
              ? GeofenceSyncStatus.permissionMissing
              : GeofenceSyncStatus.failure,
          message: failure.message,
        ),
        (count) => GeofenceSyncState(
          status: GeofenceSyncStatus.active,
          registeredCount: count,
        ),
      ),
    );
  }

  // The bloc lives as long as the Hajji is signed in, so closing it means
  // signing out: the next user of this phone must not inherit the zones.
  @override
  Future<void> close() async {
    await _clear.execute(const NoParams());
    return super.close();
  }
}
