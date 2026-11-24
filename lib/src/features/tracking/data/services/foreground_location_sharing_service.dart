import 'dart:async';

import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:hajjmate/src/core/constants/app_constants.dart';
import 'package:hajjmate/src/features/tracking/data/services/location_task_handler.dart';
import 'package:hajjmate/src/features/tracking/domain/services/location_sharing_service.dart';

class ForegroundLocationSharingService implements LocationSharingService {
  static const int _serviceId = 256;

  final StreamController<DateTime> _lastSent = StreamController.broadcast();

  ForegroundLocationSharingService() {
    FlutterForegroundTask.addTaskDataCallback(_onTaskData);
  }

  void _onTaskData(Object data) {
    if (data is Map && data[sentAtKey] is int) {
      _lastSent.add(
        DateTime.fromMillisecondsSinceEpoch(data[sentAtKey] as int),
      );
    }
  }

  @override
  Stream<DateTime> get lastSentAt => _lastSent.stream;

  @override
  Future<bool> start({
    required String userId,
    required String name,
    required String groupId,
  }) async {
    if (await FlutterForegroundTask.isRunningService) return true;

    FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        channelId: 'location_sharing',
        channelName: 'Location sharing',
        channelDescription: 'Shown while your location is shared.',
        onlyAlertOnce: true,
      ),
      iosNotificationOptions: const IOSNotificationOptions(),
      foregroundTaskOptions: ForegroundTaskOptions(
        eventAction: ForegroundTaskEventAction.repeat(
          AppConstants.locationUpdateInterval.inMilliseconds,
        ),
        allowWakeLock: true,
        allowWifiLock: true,
      ),
    );
    await FlutterForegroundTask.saveData(key: userIdKey, value: userId);
    await FlutterForegroundTask.saveData(key: nameKey, value: name);
    await FlutterForegroundTask.saveData(key: groupIdKey, value: groupId);

    final result = await FlutterForegroundTask.startService(
      serviceId: _serviceId,
      notificationTitle: 'Location sharing is on',
      notificationText: 'Starting...',
      callback: locationServiceCallback,
    );
    return result is ServiceRequestSuccess;
  }

  @override
  Future<void> stop() async {
    await FlutterForegroundTask.stopService();
  }

  @override
  Future<bool> isRunning() => FlutterForegroundTask.isRunningService;
}
