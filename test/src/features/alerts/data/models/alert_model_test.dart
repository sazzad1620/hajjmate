import 'package:flutter_test/flutter_test.dart';
import 'package:hajjmate/src/features/alerts/data/models/alert_model.dart';
import 'package:hajjmate/src/features/alerts/domain/entities/alert.dart';
import 'package:hajjmate/src/features/alerts/domain/entities/alert_type.dart';
import 'package:hajjmate/src/shared/models/coordinates.dart';

void main() {
  group('AlertModel.toMap', () {
    test('writes the fields of the alert list', () {
      final alert = Alert(
        type: AlertType.exit,
        groupId: 'default',
        userId: 'u1',
        userName: 'Rahim',
        zoneId: 'z1',
        zoneName: 'Hotel',
        position: const Coordinates(latitude: 21.4225, longitude: 39.8262),
        timestamp: DateTime.fromMillisecondsSinceEpoch(1764000000000),
      );

      expect(AlertModel(alert).toMap(), {
        'type': 'exit',
        'userId': 'u1',
        'userName': 'Rahim',
        'zoneId': 'z1',
        'zoneName': 'Hotel',
        'latitude': 21.4225,
        'longitude': 39.8262,
        'timestamp': 1764000000000,
      });
    });
  });
}
