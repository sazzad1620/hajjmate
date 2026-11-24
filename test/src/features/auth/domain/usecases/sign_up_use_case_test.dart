import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hajjmate/src/core/errors/failures.dart';
import 'package:hajjmate/src/features/auth/domain/entities/leader.dart';
import 'package:hajjmate/src/features/auth/domain/entities/role.dart';
import 'package:hajjmate/src/features/auth/domain/entities/sign_up_params.dart';
import 'package:hajjmate/src/features/auth/domain/repositories/auth_repository.dart';
import 'package:hajjmate/src/features/auth/domain/usecases/sign_up_use_case.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository repository;
  late SignUpUseCase useCase;

  const params = SignUpParams(
    name: 'Karim',
    phone: '01812345678',
    email: 'karim@example.com',
    password: 'secret1',
    role: Role.leader,
  );
  const user = Leader(
    id: 'u2',
    name: 'Karim',
    phone: '01812345678',
    email: 'karim@example.com',
    groupId: 'default',
  );

  setUp(() {
    repository = MockAuthRepository();
    useCase = SignUpUseCase(repository);
  });

  group('SignUpUseCase', () {
    test('returns the new user when sign-up succeeds', () async {
      when(
        () => repository.signUp(params),
      ).thenAnswer((_) async => const Right(user));

      final result = await useCase.execute(params);

      expect(result, const Right(user));
      verify(() => repository.signUp(params)).called(1);
      verifyNoMoreInteractions(repository);
    });

    test('returns the failure when the email is already registered', () async {
      const failure = AuthFailure(message: 'This email is already registered.');
      when(
        () => repository.signUp(params),
      ).thenAnswer((_) async => const Left(failure));

      final result = await useCase.execute(params);

      expect(result, const Left(failure));
    });
  });
}
