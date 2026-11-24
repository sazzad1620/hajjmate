import 'package:equatable/equatable.dart';
import 'package:hajjmate/src/shared/models/coordinates.dart';

class LocationUpdate extends Equatable {
  final String userId;
  final String name;
  final String groupId;
  final Coordinates position;
  final DateTime timestamp;

  const LocationUpdate({
    required this.userId,
    required this.name,
    required this.groupId,
    required this.position,
    required this.timestamp,
  });

  @override
  List<Object?> get props => [userId, name, groupId, position, timestamp];
}
