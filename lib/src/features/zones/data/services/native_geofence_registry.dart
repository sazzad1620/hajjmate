import 'package:dartz/dartz.dart';
import 'package:hajjmate/src/core/errors/error_handler.dart';
import 'package:hajjmate/src/core/errors/failures.dart';
import 'package:hajjmate/src/features/alerts/data/geofence_callback.dart';
import 'package:hajjmate/src/features/zones/domain/entities/zone.dart';
import 'package:hajjmate/src/features/zones/domain/services/geofence_registry.dart';
import 'package:native_geofence/native_geofence.dart' as ng;
import 'package:permission_handler/permission_handler.dart';

class NativeGeofenceRegistry implements GeofenceRegistry {
  static const double _sameCentre = 0.000001;
  static const double _sameRadiusM = 0.5;

  final ErrorHandler _errorHandler;
  bool _initialized = false;

  NativeGeofenceRegistry(this._errorHandler);

  ng.NativeGeofenceManager get _manager => ng.NativeGeofenceManager.instance;

  Future<void> _ensureInitialized() async {
    if (_initialized) return;
    await _manager.initialize();
    _initialized = true;
  }

  @override
  Future<Either<Failure, int>> sync(List<Zone> zones) async {
    try {
      if (!await Permission.locationAlways.isGranted) {
        return const Left(
          PermissionFailure(
            message: 'Allow location all the time to get zone alerts.',
          ),
        );
      }
      await _ensureInitialized();

      final registered = {
        for (final geofence in await _manager.getRegisteredGeofences())
          geofence.id: geofence,
      };
      final wanted = {for (final zone in zones) zone.id: zone};

      for (final id in registered.keys) {
        if (!wanted.containsKey(id)) await _manager.removeGeofenceById(id);
      }
      for (final zone in zones) {
        final existing = registered[zone.id];
        if (existing != null && _matches(existing, zone)) continue;
        if (existing != null) await _manager.removeGeofenceById(zone.id);
        await _manager.createGeofence(_geofenceOf(zone), onGeofenceTriggered);
      }

      return Right((await _manager.getRegisteredGeofenceIds()).length);
    } catch (e) {
      return Left(_errorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, Unit>> clear() async {
    try {
      await _ensureInitialized();
      await _manager.removeAllGeofences();
      return const Right(unit);
    } catch (e) {
      return Left(_errorHandler.handle(e));
    }
  }

  @override
  Future<bool> requestPermission() async {
    // Android asks for "while in use" first, then for "all the time".
    if (!await Permission.location.request().isGranted) return false;
    final status = await Permission.locationAlways.request();
    if (status.isPermanentlyDenied) await openAppSettings();
    return status.isGranted;
  }

  // A Hajji who already stands inside a new zone gets an enter alert at once.
  ng.Geofence _geofenceOf(Zone zone) {
    return ng.Geofence(
      id: zone.id,
      location: ng.Location(
        latitude: zone.centre.latitude,
        longitude: zone.centre.longitude,
      ),
      radiusMeters: zone.radiusM,
      triggers: {ng.GeofenceEvent.enter, ng.GeofenceEvent.exit},
      iosSettings: const ng.IosGeofenceSettings(initialTrigger: true),
      androidSettings: const ng.AndroidGeofenceSettings(
        initialTriggers: {ng.GeofenceEvent.enter},
        notificationResponsiveness: Duration(seconds: 30),
      ),
    );
  }

  bool _matches(ng.ActiveGeofence geofence, Zone zone) {
    return (geofence.location.latitude - zone.centre.latitude).abs() <
            _sameCentre &&
        (geofence.location.longitude - zone.centre.longitude).abs() <
            _sameCentre &&
        (geofence.radiusMeters - zone.radiusM).abs() < _sameRadiusM;
  }
}
