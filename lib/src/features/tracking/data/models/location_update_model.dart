import 'package:hajjmate/src/features/tracking/domain/entities/location_update.dart';
import 'package:hajjmate/src/shared/models/coordinates.dart';

class LocationUpdateModel {
  final LocationUpdate update;

  const LocationUpdateModel(this.update);

  factory LocationUpdateModel.fromMap({
    required String userId,
    required String groupId,
    required Map<Object?, Object?> map,
  }) {
    return LocationUpdateModel(
      LocationUpdate(
        userId: userId,
        name: map['name'] as String,
        groupId: groupId,
        position: Coordinates(
          latitude: (map['latitude'] as num).toDouble(),
          longitude: (map['longitude'] as num).toDouble(),
        ),
        timestamp: DateTime.fromMillisecondsSinceEpoch(
          (map['timestamp'] as num).toInt(),
        ),
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': update.name,
      'latitude': update.position.latitude,
      'longitude': update.position.longitude,
      'timestamp': update.timestamp.millisecondsSinceEpoch,
    };
  }
}
