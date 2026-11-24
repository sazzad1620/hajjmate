import 'package:dartz/dartz.dart';
import 'package:hajjmate/src/core/errors/failures.dart';
import 'package:hajjmate/src/core/interfaces/use_case.dart';
import 'package:hajjmate/src/features/auth/domain/entities/login_params.dart';
import 'package:hajjmate/src/features/auth/domain/entities/user.dart';
import 'package:hajjmate/src/features/auth/domain/repositories/auth_repository.dart';

class LoginUseCase implements UseCase<LoginParams, User> {
  final AuthRepository _repository;

  LoginUseCase(this._repository);

  @override
  Future<Either<Failure, User>> execute(LoginParams params) =>
      _repository.login(params);
}
