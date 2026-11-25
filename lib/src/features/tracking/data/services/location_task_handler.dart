import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:hajjmate/firebase_options.dart';
import 'package:hajjmate/src/core/errors/error_handler.dart';
import 'package:hajjmate/src/core/utils/time_formatter.dart';
import 'package:hajjmate/src/features/tracking/data/repositories/realtime_location_repository.dart';
import 'package:hajjmate/src/features/tracking/data/services/geolocator_device_location_provider.dart';
import 'package:hajjmate/src/features/tracking/domain/entities/location_update.dart';
import 'package:hajjmate/src/features/tracking/domain/services/device_location_provider.dart';
import 'package:hajjmate/src/features/tracking/domain/usecases/publish_location_use_case.dart';

const String userIdKey = 'sharing_user_id';
const String nameKey = 'sharing_name';
const String groupIdKey = 'sharing_group_id';
const String sentAtKey = 'sentAt';

@pragma('vm:entry-point')
void locationServiceCallback() {
  FlutterForegroundTask.setTaskHandler(LocationTaskHandler());
}

// Runs in its own isolate, where `get_it` is not set up, so it builds the
// few objects it needs itself.
class LocationTaskHandler extends TaskHandler {
  late final DeviceLocationProvider _locationProvider;
  late final PublishLocationUseCase _publishLocation;
  late final String _userId;
  late final String _name;
  late final String _groupId;

  @override
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }
    _locationProvider = GeolocatorDeviceLocationProvider();
    _publishLocation = PublishLocationUseCase(
      RealtimeLocationRepository(FirebaseDatabase.instance, ErrorHandler()),
    );
    _userId = await FlutterForegroundTask.getData<String>(key: userIdKey) ?? '';
    _name = await FlutterForegroundTask.getData<String>(key: nameKey) ?? '';
    _groupId =
        await FlutterForegroundTask.getData<String>(key: groupIdKey) ?? '';
    await _sendLocation();
  }

  @override
  void onRepeatEvent(DateTime timestamp) {
    unawaited(_sendLocation());
  }

  Future<void> _sendLocation() async {
    try {
      final position = await _locationProvider.currentPosition();
      final now = DateTime.now();
      final result = await _publishLocation.execute(
        LocationUpdate(
          userId: _userId,
          name: _name,
          groupId: _groupId,
          position: position,
          timestamp: now,
        ),
      );
      await result.fold(
        (failure) => _showStatus('Could not send: ${failure.message}'),
        (_) async {
          FlutterForegroundTask.sendDataToMain({
            sentAtKey: now.millisecondsSinceEpoch,
          });
          await _showStatus('Last sent ${TimeFormatter.clock(now)}');
        },
      );
    } catch (_) {
      await _showStatus('Waiting for your location');
    }
  }

  Future<void> _showStatus(String text) {
    return FlutterForegroundTask.updateService(notificationText: text);
  }

  @override
  Future<void> onDestroy(DateTime timestamp, bool isTimeout) async {}
}
