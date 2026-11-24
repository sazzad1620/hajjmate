import 'package:equatable/equatable.dart';
import 'package:hajjmate/src/features/auth/domain/entities/role.dart';

abstract class User extends Equatable {
  final String id;
  final String name;
  final String phone;
  final String email;
  final String groupId;

  const User({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.groupId,
  });

  Role get role;

  @override
  List<Object?> get props => [id, name, phone, email, groupId, role];
}
