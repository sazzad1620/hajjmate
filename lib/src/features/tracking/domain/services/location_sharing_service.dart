abstract class LocationSharingService {
  // Returns true when the background sharing is running afterwards.
  Future<bool> start({
    required String userId,
    required String name,
    required String groupId,
  });

  Future<void> stop();

  Future<bool> isRunning();

  Stream<DateTime> get lastSentAt;
}
