import 'package:hajjmate/src/features/alerts/domain/entities/alert.dart';

class AlertModel {
  final Alert alert;

  const AlertModel(this.alert);

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
