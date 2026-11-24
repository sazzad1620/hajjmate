import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hajjmate/src/features/auth/domain/usecases/forgot_password_use_case.dart';
import 'package:hajjmate/src/features/auth/presentation/bloc/forgot_password_event.dart';
import 'package:hajjmate/src/features/auth/presentation/bloc/forgot_password_state.dart';

class ForgotPasswordBloc
    extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  final ForgotPasswordUseCase _forgotPasswordUseCase;

  ForgotPasswordBloc(this._forgotPasswordUseCase)
    : super(const ForgotPasswordInitial()) {
    on<ForgotPasswordSubmitted>(_onSubmitted);
  }

  Future<void> _onSubmitted(
    ForgotPasswordSubmitted event,
    Emitter<ForgotPasswordState> emit,
  ) async {
    emit(const ForgotPasswordSubmitting());
    final result = await _forgotPasswordUseCase.execute(event.params);
    emit(
      result.fold<ForgotPasswordState>(
        (failure) => ForgotPasswordFailure(failure.message),
        (_) => const ForgotPasswordSuccess(),
      ),
    );
  }
}
