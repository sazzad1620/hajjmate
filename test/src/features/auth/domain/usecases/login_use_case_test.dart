import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hajjmate/src/core/errors/failures.dart';
import 'package:hajjmate/src/features/auth/domain/entities/hajji.dart';
import 'package:hajjmate/src/features/auth/domain/entities/login_params.dart';
import 'package:hajjmate/src/features/auth/domain/repositories/auth_repository.dart';
import 'package:hajjmate/src/features/auth/domain/usecases/login_use_case.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository repository;
  late LoginUseCase useCase;

  const params = LoginParams(email: 'rahim@example.com', password: 'secret1');
  const user = Hajji(
    id: 'u1',
    name: 'Rahim',
    phone: '01712345678',
    email: 'rahim@example.com',
    groupId: 'default',
  );

  setUp(() {
    repository = MockAuthRepository();
    useCase = LoginUseCase(repository);
  });

  group('LoginUseCase', () {
    test('returns the user when login succeeds', () async {
      when(
        () => repository.login(params),
      ).thenAnswer((_) async => const Right(user));

      final result = await useCase.execute(params);

      expect(result, const Right(user));
      verify(() => repository.login(params)).called(1);
      verifyNoMoreInteractions(repository);
    });

    test('returns the failure when login fails', () async {
      const failure = AuthFailure(message: 'Email or password is incorrect.');
      when(
        () => repository.login(params),
      ).thenAnswer((_) async => const Left(failure));

      final result = await useCase.execute(params);

      expect(result, const Left(failure));
    });
  });
}
