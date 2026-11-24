import 'package:flutter_test/flutter_test.dart';
import 'package:hajjmate/src/features/zones/data/models/zone_model.dart';
import 'package:hajjmate/src/features/zones/domain/entities/zone.dart';
import 'package:hajjmate/src/shared/models/coordinates.dart';

void main() {
  group('ZoneModel', () {
    test('reads a stored document, also when numbers are whole', () {
      final model = ZoneModel.fromMap(
        id: 'z1',
        map: {
          'groupId': 'default',
          'name': 'Hotel',
          'latitude': 21,
          'longitude': 39.8262,
          'radiusM': 150,
        },
      );

      expect(model.zone.id, 'z1');
      expect(model.zone.centre.latitude, 21.0);
      expect(model.zone.radiusM, 150.0);
    });

    test('writes what it reads', () {
      final zone = Zone(
        id: 'z1',
        groupId: 'default',
        name: 'Hotel',
        centre: const Coordinates(latitude: 21.4225, longitude: 39.8262),
        radiusM: 150,
      );

      final copy = ZoneModel.fromMap(
        id: 'z1',
        map: ZoneModel(zone).toMap(),
      ).zone;

      expect(copy, zone);
    });
  });
}
