import 'package:equatable/equatable.dart';

class WatchAlertsParams extends Equatable {
  final String groupId;

  const WatchAlertsParams({required this.groupId});

  @override
  List<Object?> get props => [groupId];
}
