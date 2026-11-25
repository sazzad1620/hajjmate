import 'package:equatable/equatable.dart';

// What the geofence callback needs to know: it runs on its own and only
// receives the id of a zone.
class GeofenceContext extends Equatable {
  final String userId;
  final String userName;
  final String groupId;
  final Map<String, String> zoneNames;

  const GeofenceContext({
    required this.userId,
    required this.userName,
    required this.groupId,
    required this.zoneNames,
  });

  @override
  List<Object?> get props => [userId, userName, groupId, zoneNames];
}
