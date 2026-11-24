import 'package:hajjmate/src/features/tracking/domain/entities/location_update.dart';

class LocationUpdateModel {
  final LocationUpdate update;

  const LocationUpdateModel(this.update);

  Map<String, dynamic> toMap() {
    return {
      'name': update.name,
      'latitude': update.position.latitude,
      'longitude': update.position.longitude,
      'timestamp': update.timestamp.millisecondsSinceEpoch,
    };
  }
}
