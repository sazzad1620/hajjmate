import 'package:equatable/equatable.dart';
import 'package:hajjmate/src/shared/models/coordinates.dart';

class CreateZoneParams extends Equatable {
  final String groupId;
  final String name;
  final Coordinates centre;
  final double radiusM;

  const CreateZoneParams({
    required this.groupId,
    required this.name,
    required this.centre,
    required this.radiusM,
  });

  @override
  List<Object?> get props => [groupId, name, centre, radiusM];
}
