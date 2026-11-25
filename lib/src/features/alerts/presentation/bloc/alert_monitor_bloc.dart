import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hajjmate/src/features/alerts/domain/entities/watch_alerts_params.dart';
import 'package:hajjmate/src/features/alerts/domain/usecases/start_alert_monitoring_use_case.dart';
import 'package:hajjmate/src/features/alerts/presentation/bloc/alert_monitor_event.dart';
import 'package:hajjmate/src/features/alerts/presentation/bloc/alert_monitor_state.dart';
import 'package:hajjmate/src/features/auth/domain/usecases/get_current_user_use_case.dart';
import 'package:hajjmate/src/shared/models/no_params.dart';

class AlertMonitorBloc extends Bloc<AlertMonitorEvent, AlertMonitorState> {
  final GetCurrentUserUseCase _getCurrentUser;
  final StartAlertMonitoringUseCase _start;

  AlertMonitorBloc(this._getCurrentUser, this._start)
    : super(const AlertMonitorState()) {
    on<AlertMonitorStarted>(_onStarted);
  }

  Future<void> _onStarted(
    AlertMonitorStarted event,
    Emitter<AlertMonitorState> emit,
  ) async {
    final userResult = await _getCurrentUser.execute(const NoParams());
    final user = userResult.fold((_) => null, (user) => user);
    if (user == null) {
      emit(const AlertMonitorState(status: AlertMonitorStatus.failure));
      return;
    }

    final result = await _start.execute(
      WatchAlertsParams(groupId: user.groupId),
    );
    emit(
      AlertMonitorState(
        status: result.isRight()
            ? AlertMonitorStatus.on
            : AlertMonitorStatus.failure,
      ),
    );
  }
}
