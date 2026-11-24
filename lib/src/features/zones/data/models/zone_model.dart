import 'package:hajjmate/src/features/zones/domain/entities/zone.dart';
import 'package:hajjmate/src/shared/models/coordinates.dart';

class ZoneModel {
  final Zone zone;

  const ZoneModel(this.zone);

  factory ZoneModel.fromMap({
    required String id,
    required Map<String, dynamic> map,
  }) {
    return ZoneModel(
      Zone(
        id: id,
        groupId: map['groupId'] as String,
        name: map['name'] as String,
        centre: Coordinates(
          latitude: (map['latitude'] as num).toDouble(),
          longitude: (map['longitude'] as num).toDouble(),
        ),
        radiusM: (map['radiusM'] as num).toDouble(),
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'groupId': zone.groupId,
      'name': zone.name,
      'latitude': zone.centre.latitude,
      'longitude': zone.centre.longitude,
      'radiusM': zone.radiusM,
    };
  }
}
