import 'package:equatable/equatable.dart';

class WatchGroupParams extends Equatable {
  final String groupId;

  const WatchGroupParams({required this.groupId});

  @override
  List<Object?> get props => [groupId];
}
