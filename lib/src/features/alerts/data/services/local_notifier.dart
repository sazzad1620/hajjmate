import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hajjmate/src/features/alerts/domain/services/notifier.dart';

class LocalNotifier implements Notifier {
  static const String _channelId = 'zone_alerts';
  static const String _channelName = 'Zone alerts';

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  @override
  Future<void> show({required String title, required String body}) async {
    // A background isolate starts without the plugin set up.
    await _plugin.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      ),
    );
    await _plugin.show(
      id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title: title,
      body: body,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          _channelName,
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
    );
  }
}
