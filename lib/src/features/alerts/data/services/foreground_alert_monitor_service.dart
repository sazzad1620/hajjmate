import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:hajjmate/src/features/alerts/data/services/alert_task_handler.dart';
import 'package:hajjmate/src/features/alerts/domain/services/alert_monitor_service.dart';
import 'package:permission_handler/permission_handler.dart';

class ForegroundAlertMonitorService implements AlertMonitorService {
  static const int _serviceId = 257;

  @override
  Future<bool> start({required String groupId}) async {
    if (await FlutterForegroundTask.isRunningService) return true;

    // Without it the service runs, but no alert can be shown.
    await Permission.notification.request();

    FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        channelId: 'alert_monitoring',
        channelName: 'Alert monitoring',
        channelDescription: 'Shown while the app watches for zone alerts.',
        onlyAlertOnce: true,
      ),
      iosNotificationOptions: const IOSNotificationOptions(),
      foregroundTaskOptions: ForegroundTaskOptions(
        eventAction: ForegroundTaskEventAction.nothing(),
        allowWakeLock: true,
        allowWifiLock: true,
      ),
    );
    await FlutterForegroundTask.saveData(
      key: monitorGroupIdKey,
      value: groupId,
    );

    final result = await FlutterForegroundTask.startService(
      serviceId: _serviceId,
      serviceTypes: [ForegroundServiceTypes.dataSync],
      notificationTitle: 'Watching group alerts',
      notificationText:
          'You will be told when a Hajji enters or leaves a zone.',
      callback: alertServiceCallback,
    );
    return result is ServiceRequestSuccess;
  }

  @override
  Future<void> stop() async {
    await FlutterForegroundTask.stopService();
  }
}
