import 'package:flutter_test/flutter_test.dart';
import 'package:hajjmate/src/features/zones/domain/entities/zone.dart';
import 'package:hajjmate/src/shared/models/coordinates.dart';

void main() {
  const centre = Coordinates(latitude: 21.4225, longitude: 39.8262);

  Zone zoneWith({String name = 'Hotel', double radiusM = 150}) => Zone(
    id: 'z1',
    groupId: 'default',
    name: name,
    centre: centre,
    radiusM: radiusM,
  );

  group('Zone', () {
    test('contains a point inside the radius', () {
      const inside = Coordinates(latitude: 21.4230, longitude: 39.8262);

      expect(zoneWith().contains(inside), isTrue);
    });

    test('contains a point exactly on the edge', () {
      const edge = Coordinates(latitude: 21.4235, longitude: 39.8262);
      final zone = zoneWith(radiusM: centre.distanceTo(edge));

      expect(zone.contains(edge), isTrue);
    });

    test('does not contain a point outside the radius', () {
      const outside = Coordinates(latitude: 21.4260, longitude: 39.8262);

      expect(zoneWith().contains(outside), isFalse);
    });

    test('accepts a radius of exactly 100 m', () {
      expect(zoneWith(radiusM: 100).radiusM, 100);
    });

    test('rejects a radius below 100 m', () {
      expect(() => zoneWith(radiusM: 99), throwsArgumentError);
    });

    test('rejects a blank name', () {
      expect(() => zoneWith(name: '  '), throwsArgumentError);
    });
  });
}
