import 'package:equatable/equatable.dart';

class WatchZonesParams extends Equatable {
  final String groupId;

  const WatchZonesParams({required this.groupId});

  @override
  List<Object?> get props => [groupId];
}
