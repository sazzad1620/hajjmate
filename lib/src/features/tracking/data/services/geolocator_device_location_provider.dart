import 'package:geolocator/geolocator.dart';
import 'package:hajjmate/src/features/tracking/domain/services/device_location_provider.dart';
import 'package:hajjmate/src/shared/models/coordinates.dart';
import 'package:permission_handler/permission_handler.dart';

class GeolocatorDeviceLocationProvider implements DeviceLocationProvider {
  static const Duration _positionTimeout = Duration(seconds: 20);
  static const int _minMoveM = 5;

  @override
  Future<bool> requestPermissions() async {
    final statuses = await [
      Permission.location,
      Permission.notification,
    ].request();
    return statuses[Permission.location]?.isGranted ?? false;
  }

  @override
  Future<Coordinates> currentPosition() async {
    final position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        timeLimit: _positionTimeout,
      ),
    );
    return Coordinates(
      latitude: position.latitude,
      longitude: position.longitude,
    );
  }

  @override
  Stream<Coordinates> watchPosition() {
    return Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: _minMoveM,
      ),
    ).map(
      (position) => Coordinates(
        latitude: position.latitude,
        longitude: position.longitude,
      ),
    );
  }
}
