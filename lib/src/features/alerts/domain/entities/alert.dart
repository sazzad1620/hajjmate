import 'package:equatable/equatable.dart';
import 'package:hajjmate/src/features/alerts/domain/entities/alert_type.dart';
import 'package:hajjmate/src/shared/models/coordinates.dart';

class Alert extends Equatable {
  final AlertType type;
  final String groupId;
  final String userId;
  final String userName;
  final String zoneId;
  final String zoneName;
  final Coordinates position;
  final DateTime timestamp;

  const Alert({
    required this.type,
    required this.groupId,
    required this.userId,
    required this.userName,
    required this.zoneId,
    required this.zoneName,
    required this.position,
    required this.timestamp,
  });

  String get summary {
    final action = type == AlertType.enter ? 'entered' : 'left';
    return '$userName $action $zoneName';
  }

  @override
  List<Object?> get props => [
    type,
    groupId,
    userId,
    userName,
    zoneId,
    zoneName,
    position,
    timestamp,
  ];
}
