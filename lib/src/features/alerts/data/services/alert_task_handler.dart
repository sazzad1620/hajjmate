import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:hajjmate/firebase_options.dart';
import 'package:hajjmate/src/core/errors/error_handler.dart';
import 'package:hajjmate/src/core/errors/failures.dart';
import 'package:hajjmate/src/features/alerts/data/repositories/realtime_alert_repository.dart';
import 'package:hajjmate/src/features/alerts/data/services/local_notifier.dart';
import 'package:hajjmate/src/features/alerts/domain/entities/alert.dart';
import 'package:hajjmate/src/features/alerts/domain/entities/watch_alerts_params.dart';
import 'package:hajjmate/src/features/alerts/domain/usecases/watch_new_alerts_use_case.dart';

const String monitorGroupIdKey = 'monitor_group_id';

@pragma('vm:entry-point')
void alertServiceCallback() {
  FlutterForegroundTask.setTaskHandler(AlertTaskHandler());
}

/// Runs in its own isolate, where `get_it` is not set up, so it builds the
/// few objects it needs itself.
class AlertTaskHandler extends TaskHandler {
  final LocalNotifier _notifier = LocalNotifier();
  StreamSubscription<Either<Failure, Alert>>? _subscription;

  @override
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }
    final groupId =
        await FlutterForegroundTask.getData<String>(key: monitorGroupIdKey) ??
        '';
    final watchNewAlerts = WatchNewAlertsUseCase(
      RealtimeAlertRepository(FirebaseDatabase.instance, ErrorHandler()),
    );
    _subscription = watchNewAlerts
        .execute(WatchAlertsParams(groupId: groupId))
        .listen(_onResult);
  }

  Future<void> _onResult(Either<Failure, Alert> result) async {
    final alert = result.fold((_) => null, (alert) => alert);
    if (alert == null) return;
    try {
      await _notifier.show(title: 'Zone alert', body: alert.summary);
    } catch (_) {}
  }

  @override
  void onRepeatEvent(DateTime timestamp) {}

  @override
  Future<void> onDestroy(DateTime timestamp, bool isTimeout) async {
    await _subscription?.cancel();
  }
}
