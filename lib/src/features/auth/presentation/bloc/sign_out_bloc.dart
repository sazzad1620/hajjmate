import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hajjmate/src/features/auth/domain/usecases/sign_out_use_case.dart';
import 'package:hajjmate/src/features/auth/presentation/bloc/sign_out_event.dart';
import 'package:hajjmate/src/features/auth/presentation/bloc/sign_out_state.dart';
import 'package:hajjmate/src/features/zones/domain/usecases/clear_geofences_use_case.dart';
import 'package:hajjmate/src/shared/models/no_params.dart';

class SignOutBloc extends Bloc<SignOutEvent, SignOutState> {
  final SignOutUseCase _signOutUseCase;
  final ClearGeofencesUseCase _clearGeofences;

  SignOutBloc(this._signOutUseCase, this._clearGeofences) : super(const SignOutInitial()) {
    on<SignOutRequested>(_onRequested);
  }

  Future<void> _onRequested(
    SignOutRequested event,
    Emitter<SignOutState> emit,
  ) async {
    emit(const SignOutSubmitting());
    // The next user of this phone must not inherit this Hajji's zones.
    await _clearGeofences.execute(const NoParams());
    final result = await _signOutUseCase.execute(const NoParams());
    emit(
      result.fold<SignOutState>(
        (failure) => SignOutFailure(failure.message),
        (_) => const SignOutSuccess(),
      ),
    );
  }
}
