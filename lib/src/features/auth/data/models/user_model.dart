import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hajjmate/src/features/auth/domain/entities/role.dart';
import 'package:hajjmate/src/features/auth/domain/entities/user.dart';
import 'package:hajjmate/src/features/auth/domain/entities/user_factory.dart';

class UserModel {
  final String id;
  final String name;
  final String phone;
  final String email;
  final String groupId;
  final Role role;

  const UserModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.groupId,
    required this.role,
  });

  factory UserModel.fromMap(String id, Map<String, dynamic> map) {
    return UserModel(
      id: id,
      name: map['name'] as String,
      phone: map['phone'] as String,
      email: map['email'] as String,
      groupId: map['groupId'] as String,
      role: Role.values.byName(map['role'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phone': phone,
      'email': email,
      'groupId': groupId,
      'role': role.name,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }

  User toEntity() {
    return UserFactory.fromRole(
      role: role,
      id: id,
      name: name,
      phone: phone,
      email: email,
      groupId: groupId,
    );
  }
}
