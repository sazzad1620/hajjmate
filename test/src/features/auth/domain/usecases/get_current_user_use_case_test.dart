import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hajjmate/src/core/errors/failures.dart';
import 'package:hajjmate/src/features/auth/domain/entities/leader.dart';
import 'package:hajjmate/src/features/auth/domain/entities/user.dart';
import 'package:hajjmate/src/features/auth/domain/repositories/auth_repository.dart';
import 'package:hajjmate/src/features/auth/domain/usecases/get_current_user_use_case.dart';
import 'package:hajjmate/src/shared/models/no_params.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository repository;
  late GetCurrentUserUseCase useCase;

  const user = Leader(
    id: 'u2',
    name: 'Karim',
    phone: '01812345678',
    email: 'karim@example.com',
    groupId: 'default',
  );

  setUp(() {
    repository = MockAuthRepository();
    useCase = GetCurrentUserUseCase(repository);
  });

  group('GetCurrentUserUseCase', () {
    test('returns the signed-in user', () async {
      when(
        () => repository.getCurrentUser(),
      ).thenAnswer((_) async => const Right<Failure, User?>(user));

      final result = await useCase.execute(const NoParams());

      expect(result, const Right<Failure, User?>(user));
      verify(() => repository.getCurrentUser()).called(1);
      verifyNoMoreInteractions(repository);
    });

    test('returns null when nobody is signed in', () async {
      when(
        () => repository.getCurrentUser(),
      ).thenAnswer((_) async => const Right<Failure, User?>(null));

      final result = await useCase.execute(const NoParams());

      expect(result, const Right<Failure, User?>(null));
    });

    test('returns the failure when the profile cannot be loaded', () async {
      const failure = AuthFailure(message: 'Your profile was not found.');
      when(
        () => repository.getCurrentUser(),
      ).thenAnswer((_) async => const Left<Failure, User?>(failure));

      final result = await useCase.execute(const NoParams());

      expect(result, const Left<Failure, User?>(failure));
    });
  });
}
