import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hajjmate/src/features/auth/domain/usecases/login_use_case.dart';
import 'package:hajjmate/src/features/auth/presentation/bloc/login_event.dart';
import 'package:hajjmate/src/features/auth/presentation/bloc/login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginUseCase _loginUseCase;

  LoginBloc(this._loginUseCase) : super(const LoginInitial()) {
    on<LoginSubmitted>(_onSubmitted);
  }

  Future<void> _onSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    emit(const LoginSubmitting());
    final result = await _loginUseCase.execute(event.params);
    emit(
      result.fold<LoginState>(
        (failure) => LoginFailure(failure.message),
        (user) => LoginSuccess(user),
      ),
    );
  }
}
