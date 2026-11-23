import 'dart:math';

import 'package:equatable/equatable.dart';

class Coordinates extends Equatable {
  static const double _earthRadiusM = 6371000;

  final double latitude;
  final double longitude;

  const Coordinates({required this.latitude, required this.longitude})
    : assert(latitude >= -90 && latitude <= 90),
      assert(longitude >= -180 && longitude <= 180);

  double distanceTo(Coordinates other) {
    final lat1 = _toRadians(latitude);
    final lat2 = _toRadians(other.latitude);
    final deltaLat = lat2 - lat1;
    final deltaLng = _toRadians(other.longitude - longitude);

    final a =
        pow(sin(deltaLat / 2), 2) +
        cos(lat1) * cos(lat2) * pow(sin(deltaLng / 2), 2);
    return 2 * _earthRadiusM * asin(sqrt(a));
  }

  static double _toRadians(double degrees) => degrees * pi / 180;

  @override
  List<Object?> get props => [latitude, longitude];
}
