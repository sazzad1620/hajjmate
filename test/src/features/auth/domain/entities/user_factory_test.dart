import 'package:flutter_test/flutter_test.dart';
import 'package:hajjmate/src/features/auth/domain/entities/hajji.dart';
import 'package:hajjmate/src/features/auth/domain/entities/leader.dart';
import 'package:hajjmate/src/features/auth/domain/entities/role.dart';
import 'package:hajjmate/src/features/auth/domain/entities/user.dart';
import 'package:hajjmate/src/features/auth/domain/entities/user_factory.dart';

User _build(Role role) {
  return UserFactory.fromRole(
    role: role,
    id: 'u1',
    name: 'Rahim',
    phone: '01712345678',
    email: 'rahim@example.com',
    groupId: 'default',
  );
}

void main() {
  group('UserFactory.fromRole', () {
    test('creates a Leader for the leader role', () {
      expect(_build(Role.leader), isA<Leader>());
    });

    test('creates a Hajji for the hajji role', () {
      expect(_build(Role.hajji), isA<Hajji>());
    });

    test('each user reports its own role', () {
      expect(_build(Role.leader).role, Role.leader);
      expect(_build(Role.hajji).role, Role.hajji);
    });
  });
}
