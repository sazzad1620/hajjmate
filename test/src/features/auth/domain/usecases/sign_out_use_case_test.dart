import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hajjmate/src/core/errors/failures.dart';
import 'package:hajjmate/src/features/auth/domain/repositories/auth_repository.dart';
import 'package:hajjmate/src/features/auth/domain/usecases/sign_out_use_case.dart';
import 'package:hajjmate/src/shared/models/no_params.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository repository;
  late SignOutUseCase useCase;

  setUp(() {
    repository = MockAuthRepository();
    useCase = SignOutUseCase(repository);
  });

  group('SignOutUseCase', () {
    test('returns unit when sign out succeeds', () async {
      when(
        () => repository.signOut(),
      ).thenAnswer((_) async => const Right(unit));

      final result = await useCase.execute(const NoParams());

      expect(result, const Right(unit));
      verify(() => repository.signOut()).called(1);
      verifyNoMoreInteractions(repository);
    });

    test('returns the failure when sign out fails', () async {
      const failure = UnknownFailure();
      when(
        () => repository.signOut(),
      ).thenAnswer((_) async => const Left(failure));

      final result = await useCase.execute(const NoParams());

      expect(result, const Left(failure));
    });
  });
}
