/// Keeps the leader's phone listening for new alerts in the background.
abstract class AlertMonitorService {
  /// Returns true when the monitoring is running afterwards.
  Future<bool> start({required String groupId});

  Future<void> stop();
}
