import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hajjmate/src/features/auth/domain/usecases/sign_up_use_case.dart';
import 'package:hajjmate/src/features/auth/presentation/bloc/sign_up_event.dart';
import 'package:hajjmate/src/features/auth/presentation/bloc/sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final SignUpUseCase _signUpUseCase;

  SignUpBloc(this._signUpUseCase) : super(const SignUpInitial()) {
    on<SignUpSubmitted>(_onSubmitted);
  }

  Future<void> _onSubmitted(
    SignUpSubmitted event,
    Emitter<SignUpState> emit,
  ) async {
    emit(const SignUpSubmitting());
    final result = await _signUpUseCase.execute(event.params);
    emit(
      result.fold<SignUpState>(
        (failure) => SignUpFailure(failure.message),
        (user) => SignUpSuccess(user),
      ),
    );
  }
}
