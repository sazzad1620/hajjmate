import 'package:dartz/dartz.dart';
import 'package:hajjmate/src/core/errors/failures.dart';
import 'package:hajjmate/src/core/interfaces/use_case.dart';
import 'package:hajjmate/src/features/auth/domain/entities/forgot_password_params.dart';
import 'package:hajjmate/src/features/auth/domain/repositories/auth_repository.dart';

class ForgotPasswordUseCase implements UseCase<ForgotPasswordParams, Unit> {
  final AuthRepository _repository;

  ForgotPasswordUseCase(this._repository);

  @override
  Future<Either<Failure, Unit>> execute(ForgotPasswordParams params) =>
      _repository.sendPasswordReset(params);
}
