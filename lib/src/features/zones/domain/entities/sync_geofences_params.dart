import 'package:equatable/equatable.dart';
import 'package:hajjmate/src/features/zones/domain/entities/zone.dart';

class SyncGeofencesParams extends Equatable {
  final String userId;
  final String userName;
  final String groupId;
  final List<Zone> zones;

  const SyncGeofencesParams({
    required this.userId,
    required this.userName,
    required this.groupId,
    required this.zones,
  });

  @override
  List<Object?> get props => [userId, userName, groupId, zones];
}
