import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hajjmate/src/core/errors/failures.dart';
import 'package:hajjmate/src/features/auth/domain/entities/forgot_password_params.dart';
import 'package:hajjmate/src/features/auth/domain/repositories/auth_repository.dart';
import 'package:hajjmate/src/features/auth/domain/usecases/forgot_password_use_case.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository repository;
  late ForgotPasswordUseCase useCase;

  const params = ForgotPasswordParams(email: 'rahim@example.com');

  setUp(() {
    repository = MockAuthRepository();
    useCase = ForgotPasswordUseCase(repository);
  });

  group('ForgotPasswordUseCase', () {
    test('returns unit when the reset email is sent', () async {
      when(
        () => repository.sendPasswordReset(params),
      ).thenAnswer((_) async => const Right(unit));

      final result = await useCase.execute(params);

      expect(result, const Right(unit));
      verify(() => repository.sendPasswordReset(params)).called(1);
      verifyNoMoreInteractions(repository);
    });

    test('returns the failure when there is no connection', () async {
      const failure = NetworkFailure();
      when(
        () => repository.sendPasswordReset(params),
      ).thenAnswer((_) async => const Left(failure));

      final result = await useCase.execute(params);

      expect(result, const Left(failure));
    });
  });
}
