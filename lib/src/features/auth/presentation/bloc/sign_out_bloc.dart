import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hajjmate/src/features/auth/domain/usecases/sign_out_use_case.dart';
import 'package:hajjmate/src/features/auth/presentation/bloc/sign_out_event.dart';
import 'package:hajjmate/src/features/auth/presentation/bloc/sign_out_state.dart';
import 'package:hajjmate/src/shared/models/no_params.dart';

class SignOutBloc extends Bloc<SignOutEvent, SignOutState> {
  final SignOutUseCase _signOutUseCase;

  SignOutBloc(this._signOutUseCase) : super(const SignOutInitial()) {
    on<SignOutRequested>(_onRequested);
  }

  Future<void> _onRequested(
    SignOutRequested event,
    Emitter<SignOutState> emit,
  ) async {
    emit(const SignOutSubmitting());
    final result = await _signOutUseCase.execute(const NoParams());
    emit(
      result.fold<SignOutState>(
        (failure) => SignOutFailure(failure.message),
        (_) => const SignOutSuccess(),
      ),
    );
  }
}
