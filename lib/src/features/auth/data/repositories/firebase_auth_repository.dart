import 'package:dartz/dartz.dart';
import 'package:hajjmate/src/core/errors/error_handler.dart';
import 'package:hajjmate/src/core/errors/failures.dart';
import 'package:hajjmate/src/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:hajjmate/src/features/auth/domain/entities/forgot_password_params.dart';
import 'package:hajjmate/src/features/auth/domain/entities/login_params.dart';
import 'package:hajjmate/src/features/auth/domain/entities/sign_up_params.dart';
import 'package:hajjmate/src/features/auth/domain/entities/user.dart';
import 'package:hajjmate/src/features/auth/domain/repositories/auth_repository.dart';

class FirebaseAuthRepository implements AuthRepository {
  final AuthRemoteDatasource _datasource;
  final ErrorHandler _errorHandler;

  FirebaseAuthRepository(this._datasource, this._errorHandler);

  @override
  Future<Either<Failure, User>> login(LoginParams params) async {
    try {
      final model = await _datasource.signIn(params);
      return Right(model.toEntity());
    } catch (e) {
      return Left(_errorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, User>> signUp(SignUpParams params) async {
    try {
      final model = await _datasource.signUp(params);
      return Right(model.toEntity());
    } catch (e) {
      return Left(_errorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, Unit>> sendPasswordReset(
    ForgotPasswordParams params,
  ) async {
    try {
      await _datasource.sendPasswordReset(params);
      return const Right(unit);
    } catch (e) {
      return Left(_errorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, User?>> getCurrentUser() async {
    try {
      final model = await _datasource.getCurrentUser();
      return Right(model?.toEntity());
    } catch (e) {
      return Left(_errorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, Unit>> signOut() async {
    try {
      await _datasource.signOut();
      return const Right(unit);
    } catch (e) {
      return Left(_errorHandler.handle(e));
    }
  }
}
