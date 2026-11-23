import 'package:flutter_test/flutter_test.dart';
import 'package:hajjmate/src/shared/models/coordinates.dart';

void main() {
  const origin = Coordinates(latitude: 0, longitude: 0);

  group('Coordinates.distanceTo', () {
    test('is zero for the same point', () {
      expect(origin.distanceTo(origin), 0);
    });

    test('is about 111 km for one degree of longitude on the equator', () {
      const oneDegreeEast = Coordinates(latitude: 0, longitude: 1);

      expect(origin.distanceTo(oneDegreeEast), closeTo(111195, 50));
    });

    test('is the same in both directions', () {
      const other = Coordinates(latitude: 21.4225, longitude: 39.8262);

      expect(origin.distanceTo(other), other.distanceTo(origin));
    });
  });
}
