abstract class AlertMonitorService {
  Future<bool> start({required String groupId});

  Future<void> stop();
}
