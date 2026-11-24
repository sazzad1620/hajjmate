import 'package:dartz/dartz.dart';
import 'package:hajjmate/src/core/errors/failures.dart';
import 'package:hajjmate/src/core/interfaces/use_case.dart';
import 'package:hajjmate/src/features/auth/domain/entities/sign_up_params.dart';
import 'package:hajjmate/src/features/auth/domain/entities/user.dart';
import 'package:hajjmate/src/features/auth/domain/repositories/auth_repository.dart';

class SignUpUseCase implements UseCase<SignUpParams, User> {
  final AuthRepository _repository;

  SignUpUseCase(this._repository);

  @override
  Future<Either<Failure, User>> execute(SignUpParams params) =>
      _repository.signUp(params);
}
