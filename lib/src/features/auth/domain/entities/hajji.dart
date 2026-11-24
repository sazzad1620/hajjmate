import 'package:hajjmate/src/features/auth/domain/entities/role.dart';
import 'package:hajjmate/src/features/auth/domain/entities/user.dart';

class Hajji extends User {
  const Hajji({
    required super.id,
    required super.name,
    required super.phone,
    required super.email,
    required super.groupId,
  });

  @override
  Role get role => Role.hajji;
}
