import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hajjmate/src/core/errors/failures.dart';
import 'package:hajjmate/src/features/alerts/domain/entities/alert.dart';
import 'package:hajjmate/src/features/alerts/domain/entities/watch_alerts_params.dart';
import 'package:hajjmate/src/features/alerts/domain/usecases/watch_alerts_use_case.dart';
import 'package:hajjmate/src/features/alerts/presentation/bloc/alert_list_event.dart';
import 'package:hajjmate/src/features/alerts/presentation/bloc/alert_list_state.dart';
import 'package:hajjmate/src/features/auth/domain/usecases/get_current_user_use_case.dart';
import 'package:hajjmate/src/shared/models/no_params.dart';

class AlertListBloc extends Bloc<AlertListEvent, AlertListState> {
  final GetCurrentUserUseCase _getCurrentUser;
  final WatchAlertsUseCase _watchAlerts;

  AlertListBloc(this._getCurrentUser, this._watchAlerts)
    : super(const AlertListState()) {
    on<AlertListStarted>(_onStarted);
  }

  Future<void> _onStarted(
    AlertListStarted event,
    Emitter<AlertListState> emit,
  ) async {
    final userResult = await _getCurrentUser.execute(const NoParams());
    final user = userResult.fold((_) => null, (user) => user);
    if (user == null) {
      emit(
        const AlertListState(
          status: AlertListStatus.failure,
          message: 'Could not load your profile. Sign in again.',
        ),
      );
      return;
    }

    await emit.forEach<Either<Failure, List<Alert>>>(
      _watchAlerts.execute(WatchAlertsParams(groupId: user.groupId)),
      onData: (result) => result.fold(
        (failure) => AlertListState(
          status: AlertListStatus.failure,
          alerts: state.alerts,
          message: failure.message,
        ),
        (alerts) =>
            AlertListState(status: AlertListStatus.ready, alerts: alerts),
      ),
    );
  }
}
