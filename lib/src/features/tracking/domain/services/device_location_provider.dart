import 'package:hajjmate/src/shared/models/coordinates.dart';

abstract class DeviceLocationProvider {
  // Returns true when the app may read the phone's location.
  Future<bool> requestPermissions();

  Future<Coordinates> currentPosition();

  // Emits again each time the phone moves a few metres.
  Stream<Coordinates> watchPosition();
}
