import 'package:dartz/dartz.dart';
import 'package:hajjmate/src/core/errors/failures.dart';
import 'package:hajjmate/src/features/auth/domain/entities/forgot_password_params.dart';
import 'package:hajjmate/src/features/auth/domain/entities/login_params.dart';
import 'package:hajjmate/src/features/auth/domain/entities/sign_up_params.dart';
import 'package:hajjmate/src/features/auth/domain/entities/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> login(LoginParams params);

  Future<Either<Failure, User>> signUp(SignUpParams params);

  Future<Either<Failure, Unit>> sendPasswordReset(ForgotPasswordParams params);

  /// The right side is null when nobody is signed in.
  Future<Either<Failure, User?>> getCurrentUser();

  Future<Either<Failure, Unit>> signOut();
}
