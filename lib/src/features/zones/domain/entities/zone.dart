import 'package:equatable/equatable.dart';
import 'package:hajjmate/src/core/constants/app_constants.dart';
import 'package:hajjmate/src/shared/models/coordinates.dart';

class Zone extends Equatable {
  final String id;
  final String groupId;
  final String name;
  final Coordinates _centre;
  final double _radiusM;

  /// Throws [ArgumentError] when the name is blank or the radius is too small.
  Zone({
    required this.id,
    required this.groupId,
    required this.name,
    required Coordinates centre,
    required double radiusM,
    // A named parameter cannot be private, so the fields are set here.
    // ignore: prefer_initializing_formals
  }) : _centre = centre,
       _radiusM = radiusM {
    if (name.trim().isEmpty) {
      throw ArgumentError('Enter a zone name.');
    }
    if (radiusM < AppConstants.minZoneRadiusM) {
      throw ArgumentError(
        'The radius must be at least ${AppConstants.minZoneRadiusM.round()} m.',
      );
    }
  }

  Coordinates get centre => _centre;

  double get radiusM => _radiusM;

  /// A point exactly on the edge counts as inside.
  bool contains(Coordinates point) => _centre.distanceTo(point) <= _radiusM;

  @override
  List<Object?> get props => [id, groupId, name, _centre, _radiusM];
}
