import 'package:hajjmate/src/features/auth/domain/entities/hajji.dart';
import 'package:hajjmate/src/features/auth/domain/entities/leader.dart';
import 'package:hajjmate/src/features/auth/domain/entities/role.dart';
import 'package:hajjmate/src/features/auth/domain/entities/user.dart';

class UserFactory {
  UserFactory._();

  static User fromRole({
    required Role role,
    required String id,
    required String name,
    required String phone,
    required String email,
    required String groupId,
  }) {
    return switch (role) {
      Role.leader => Leader(
        id: id,
        name: name,
        phone: phone,
        email: email,
        groupId: groupId,
      ),
      Role.hajji => Hajji(
        id: id,
        name: name,
        phone: phone,
        email: email,
        groupId: groupId,
      ),
    };
  }
}
