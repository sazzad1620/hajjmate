import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hajjmate/src/core/errors/failures.dart';
import 'package:hajjmate/src/features/auth/domain/usecases/get_current_user_use_case.dart';
import 'package:hajjmate/src/features/tracking/domain/services/device_location_provider.dart';
import 'package:hajjmate/src/features/zones/domain/entities/create_zone_params.dart';
import 'package:hajjmate/src/features/zones/domain/entities/delete_zone_params.dart';
import 'package:hajjmate/src/features/zones/domain/entities/update_zone_params.dart';
import 'package:hajjmate/src/features/zones/domain/usecases/create_zone_use_case.dart';
import 'package:hajjmate/src/features/zones/domain/usecases/delete_zone_use_case.dart';
import 'package:hajjmate/src/features/zones/domain/usecases/update_zone_use_case.dart';
import 'package:hajjmate/src/features/zones/presentation/bloc/zone_form_event.dart';
import 'package:hajjmate/src/features/zones/presentation/bloc/zone_form_state.dart';
import 'package:hajjmate/src/shared/models/no_params.dart';

class ZoneFormBloc extends Bloc<ZoneFormEvent, ZoneFormState> {
  final GetCurrentUserUseCase _getCurrentUser;
  final CreateZoneUseCase _createZone;
  final UpdateZoneUseCase _updateZone;
  final DeleteZoneUseCase _deleteZone;
  final DeviceLocationProvider _locationProvider;

  ZoneFormBloc(
    this._getCurrentUser,
    this._createZone,
    this._updateZone,
    this._deleteZone,
    this._locationProvider,
  ) : super(const ZoneFormState()) {
    on<ZoneFormStarted>(_onStarted);
    on<ZoneCentreSelected>(_onCentreSelected);
    on<ZoneRadiusChanged>(
      (event, emit) => emit(
        state.copyWith(radiusM: event.radiusM, status: ZoneFormStatus.editing),
      ),
    );
    on<ZoneSubmitted>(_onSubmitted);
    on<ZoneDeleted>(_onDeleted);
  }

  Future<void> _onStarted(
    ZoneFormStarted event,
    Emitter<ZoneFormState> emit,
  ) async {
    final zone = event.zone;
    if (zone != null) {
      emit(
        ZoneFormState(
          editingZone: zone,
          centre: zone.centre,
          startPosition: zone.centre,
          radiusM: zone.radiusM,
        ),
      );
      return;
    }

    // Without a position the map just opens at its default place.
    try {
      if (!await _locationProvider.requestPermissions()) return;
      final position = await _locationProvider.currentPosition();
      emit(state.copyWith(startPosition: position));
    } catch (_) {}
  }

  void _onCentreSelected(
    ZoneCentreSelected event,
    Emitter<ZoneFormState> emit,
  ) {
    // The centre of an existing zone cannot be moved.
    if (state.editingZone != null) return;
    emit(state.copyWith(centre: event.centre, status: ZoneFormStatus.editing));
  }

  Future<void> _onSubmitted(
    ZoneSubmitted event,
    Emitter<ZoneFormState> emit,
  ) async {
    final editingZone = state.editingZone;
    if (editingZone != null) {
      emit(state.copyWith(status: ZoneFormStatus.submitting));
      final result = await _updateZone.execute(
        UpdateZoneParams(
          zone: editingZone,
          name: event.name,
          radiusM: state.radiusM,
        ),
      );
      emit(_finished(result));
      return;
    }

    final centre = state.centre;
    if (centre == null) {
      emit(
        state.copyWith(
          status: ZoneFormStatus.failure,
          message: 'Tap the map to place the zone.',
        ),
      );
      return;
    }

    emit(state.copyWith(status: ZoneFormStatus.submitting));
    final userResult = await _getCurrentUser.execute(const NoParams());
    final user = userResult.fold((_) => null, (user) => user);
    if (user == null) {
      emit(
        state.copyWith(
          status: ZoneFormStatus.failure,
          message: 'Could not load your profile. Sign in again.',
        ),
      );
      return;
    }

    final result = await _createZone.execute(
      CreateZoneParams(
        groupId: user.groupId,
        name: event.name,
        centre: centre,
        radiusM: state.radiusM,
      ),
    );
    emit(_finished(result));
  }

  Future<void> _onDeleted(
    ZoneDeleted event,
    Emitter<ZoneFormState> emit,
  ) async {
    final editingZone = state.editingZone;
    if (editingZone == null) return;

    emit(state.copyWith(status: ZoneFormStatus.submitting));
    final result = await _deleteZone.execute(
      DeleteZoneParams(zoneId: editingZone.id),
    );
    emit(_finished(result));
  }

  ZoneFormState _finished(Either<Failure, Unit> result) {
    return result.fold(
      (failure) => state.copyWith(
        status: ZoneFormStatus.failure,
        message: failure.message,
      ),
      (_) => state.copyWith(status: ZoneFormStatus.success),
    );
  }
}
