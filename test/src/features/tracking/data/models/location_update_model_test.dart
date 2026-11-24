import 'package:flutter_test/flutter_test.dart';
import 'package:hajjmate/src/features/tracking/data/models/location_update_model.dart';

void main() {
  group('LocationUpdateModel.fromMap', () {
    test('reads a stored location', () {
      final model = LocationUpdateModel.fromMap(
        userId: 'u1',
        groupId: 'default',
        map: {
          'name': 'Rahim',
          'latitude': 21.4225,
          'longitude': 39,
          'timestamp': 1795000000000,
        },
      );

      expect(model.update.userId, 'u1');
      expect(model.update.name, 'Rahim');
      expect(model.update.position.latitude, 21.4225);
      expect(model.update.position.longitude, 39.0);
      expect(
        model.update.timestamp,
        DateTime.fromMillisecondsSinceEpoch(1795000000000),
      );
    });

    test('toMap writes the same fields back', () {
      final model = LocationUpdateModel.fromMap(
        userId: 'u1',
        groupId: 'default',
        map: {
          'name': 'Rahim',
          'latitude': 21.4225,
          'longitude': 39.8262,
          'timestamp': 1795000000000,
        },
      );

      expect(model.toMap(), {
        'name': 'Rahim',
        'latitude': 21.4225,
        'longitude': 39.8262,
        'timestamp': 1795000000000,
      });
    });
  });
}
