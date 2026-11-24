import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hajjmate/src/features/auth/domain/usecases/get_current_user_use_case.dart';
import 'package:hajjmate/src/features/tracking/domain/entities/start_sharing_params.dart';
import 'package:hajjmate/src/features/tracking/domain/services/location_sharing_service.dart';
import 'package:hajjmate/src/features/tracking/domain/usecases/get_sharing_status_use_case.dart';
import 'package:hajjmate/src/features/tracking/domain/usecases/start_location_sharing_use_case.dart';
import 'package:hajjmate/src/features/tracking/domain/usecases/stop_location_sharing_use_case.dart';
import 'package:hajjmate/src/features/tracking/presentation/bloc/location_sharing_event.dart';
import 'package:hajjmate/src/features/tracking/presentation/bloc/location_sharing_state.dart';
import 'package:hajjmate/src/shared/models/no_params.dart';

class LocationSharingBloc
    extends Bloc<LocationSharingEvent, LocationSharingState> {
  final GetCurrentUserUseCase _getCurrentUser;
  final StartLocationSharingUseCase _startSharing;
  final StopLocationSharingUseCase _stopSharing;
  final GetSharingStatusUseCase _getStatus;
  late final StreamSubscription<DateTime> _lastSentSubscription;

  LocationSharingBloc(
    this._getCurrentUser,
    this._startSharing,
    this._stopSharing,
    this._getStatus,
    LocationSharingService sharingService,
  ) : super(const LocationSharingState()) {
    on<SharingStatusRequested>(_onStatusRequested);
    on<SharingStartRequested>(_onStartRequested);
    on<SharingStopRequested>(_onStopRequested);
    on<SharingLastSentReceived>(_onLastSentReceived);
    _lastSentSubscription = sharingService.lastSentAt.listen(
      (sentAt) => add(SharingLastSentReceived(sentAt)),
    );
  }

  Future<void> _onStatusRequested(
    SharingStatusRequested event,
    Emitter<LocationSharingState> emit,
  ) async {
    final result = await _getStatus.execute(const NoParams());
    final running = result.getOrElse(() => false);
    emit(
      state.copyWith(status: running ? SharingStatus.on : SharingStatus.off),
    );
  }

  Future<void> _onStartRequested(
    SharingStartRequested event,
    Emitter<LocationSharingState> emit,
  ) async {
    emit(state.copyWith(status: SharingStatus.starting));

    final userResult = await _getCurrentUser.execute(const NoParams());
    final user = userResult.fold((_) => null, (user) => user);
    if (user == null) {
      emit(
        state.copyWith(
          status: SharingStatus.failure,
          message: 'Could not load your profile. Sign in again.',
        ),
      );
      return;
    }

    final result = await _startSharing.execute(
      StartSharingParams(
        userId: user.id,
        name: user.name,
        groupId: user.groupId,
      ),
    );
    emit(
      result.fold(
        (failure) => state.copyWith(
          status: SharingStatus.failure,
          message: failure.message,
        ),
        (_) => state.copyWith(status: SharingStatus.on),
      ),
    );
  }

  Future<void> _onStopRequested(
    SharingStopRequested event,
    Emitter<LocationSharingState> emit,
  ) async {
    await _stopSharing.execute(const NoParams());
    emit(state.copyWith(status: SharingStatus.off));
  }

  void _onLastSentReceived(
    SharingLastSentReceived event,
    Emitter<LocationSharingState> emit,
  ) {
    emit(state.copyWith(status: state.status, lastSentAt: event.sentAt));
  }

  @override
  Future<void> close() async {
    await _lastSentSubscription.cancel();
    return super.close();
  }
}
