import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:hajjmate/src/core/errors/error_handler.dart';
import 'package:hajjmate/src/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:hajjmate/src/features/auth/data/repositories/firebase_auth_repository.dart';
import 'package:hajjmate/src/features/auth/domain/repositories/auth_repository.dart';
import 'package:hajjmate/src/features/auth/domain/usecases/forgot_password_use_case.dart';
import 'package:hajjmate/src/features/auth/domain/usecases/get_current_user_use_case.dart';
import 'package:hajjmate/src/features/auth/domain/usecases/login_use_case.dart';
import 'package:hajjmate/src/features/auth/domain/usecases/sign_out_use_case.dart';
import 'package:hajjmate/src/features/auth/domain/usecases/sign_up_use_case.dart';
import 'package:hajjmate/src/features/auth/presentation/bloc/forgot_password_bloc.dart';
import 'package:hajjmate/src/features/auth/presentation/bloc/login_bloc.dart';
import 'package:hajjmate/src/features/auth/presentation/bloc/sign_out_bloc.dart';
import 'package:hajjmate/src/features/auth/presentation/bloc/sign_up_bloc.dart';
import 'package:hajjmate/src/features/splash/presentation/bloc/splash_bloc.dart';

final GetIt getIt = GetIt.instance;

// Each feature registers its classes in its own function, interface first.
void configureDependencies() {
  _registerCore();
  _registerAuth();
  _registerSplash();
}

void _registerCore() {
  getIt
    ..registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance)
    ..registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance)
    ..registerLazySingleton<ErrorHandler>(ErrorHandler.new);
}

void _registerAuth() {
  getIt
    ..registerLazySingleton<AuthRemoteDatasource>(
      () => AuthRemoteDatasource(getIt(), getIt()),
    )
    ..registerLazySingleton<AuthRepository>(
      () => FirebaseAuthRepository(getIt(), getIt()),
    )
    ..registerLazySingleton<LoginUseCase>(() => LoginUseCase(getIt()))
    ..registerLazySingleton<SignUpUseCase>(() => SignUpUseCase(getIt()))
    ..registerLazySingleton<ForgotPasswordUseCase>(
      () => ForgotPasswordUseCase(getIt()),
    )
    ..registerLazySingleton<GetCurrentUserUseCase>(
      () => GetCurrentUserUseCase(getIt()),
    )
    ..registerLazySingleton<SignOutUseCase>(() => SignOutUseCase(getIt()))
    ..registerFactory<LoginBloc>(() => LoginBloc(getIt()))
    ..registerFactory<SignUpBloc>(() => SignUpBloc(getIt()))
    ..registerFactory<ForgotPasswordBloc>(() => ForgotPasswordBloc(getIt()))
    ..registerFactory<SignOutBloc>(() => SignOutBloc(getIt()));
}

void _registerSplash() {
  getIt.registerFactory<SplashBloc>(() => SplashBloc(getIt()));
}
