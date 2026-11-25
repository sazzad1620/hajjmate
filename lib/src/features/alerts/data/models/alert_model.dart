import 'package:hajjmate/src/features/alerts/domain/entities/alert.dart';
import 'package:hajjmate/src/features/alerts/domain/entities/alert_type.dart';
import 'package:hajjmate/src/shared/models/coordinates.dart';

class AlertModel {
  final Alert alert;

  const AlertModel(this.alert);

  factory AlertModel.fromMap({
    required String groupId,
    required Map<Object?, Object?> map,
  }) {
    return AlertModel(
      Alert(
        type: map['type'] == AlertType.enter.name
            ? AlertType.enter
            : AlertType.exit,
        groupId: groupId,
        userId: map['userId'] as String,
        userName: map['userName'] as String,
        zoneId: map['zoneId'] as String,
        zoneName: map['zoneName'] as String,
        position: Coordinates(
          latitude: (map['latitude'] as num).toDouble(),
          longitude: (map['longitude'] as num).toDouble(),
        ),
        timestamp: DateTime.fromMillisecondsSinceEpoch(
          (map['timestamp'] as num).toInt(),
        ),
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'type': alert.type.name,
      'userId': alert.userId,
      'userName': alert.userName,
      'zoneId': alert.zoneId,
      'zoneName': alert.zoneName,
      'latitude': alert.position.latitude,
      'longitude': alert.position.longitude,
      'timestamp': alert.timestamp.millisecondsSinceEpoch,
    };
  }
}
