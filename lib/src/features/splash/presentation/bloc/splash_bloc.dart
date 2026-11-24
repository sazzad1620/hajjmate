import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hajjmate/src/features/auth/domain/usecases/get_current_user_use_case.dart';
import 'package:hajjmate/src/features/splash/presentation/bloc/splash_event.dart';
import 'package:hajjmate/src/features/splash/presentation/bloc/splash_state.dart';
import 'package:hajjmate/src/shared/models/no_params.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  final GetCurrentUserUseCase _getCurrentUserUseCase;

  SplashBloc(this._getCurrentUserUseCase) : super(const SplashInitial()) {
    on<SplashStarted>(_onStarted);
  }

  Future<void> _onStarted(
    SplashStarted event,
    Emitter<SplashState> emit,
  ) async {
    final result = await _getCurrentUserUseCase.execute(const NoParams());
    emit(
      result.fold<SplashState>(
        // A failure here (for example no network) sends the user to sign in.
        (_) => const SplashUnauthenticated(),
        (user) => user == null
            ? const SplashUnauthenticated()
            : SplashAuthenticated(user),
      ),
    );
  }
}
