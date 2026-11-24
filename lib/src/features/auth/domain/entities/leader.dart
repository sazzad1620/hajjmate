import 'package:hajjmate/src/features/auth/domain/entities/role.dart';
import 'package:hajjmate/src/features/auth/domain/entities/user.dart';

class Leader extends User {
  const Leader({
    required super.id,
    required super.name,
    required super.phone,
    required super.email,
    required super.groupId,
  });

  @override
  Role get role => Role.leader;
}
