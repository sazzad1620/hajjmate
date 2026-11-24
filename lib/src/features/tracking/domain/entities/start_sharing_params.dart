import 'package:equatable/equatable.dart';

class StartSharingParams extends Equatable {
  final String userId;
  final String name;
  final String groupId;

  const StartSharingParams({
    required this.userId,
    required this.name,
    required this.groupId,
  });

  @override
  List<Object?> get props => [userId, name, groupId];
}
