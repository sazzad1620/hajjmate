import 'package:equatable/equatable.dart';
import 'package:hajjmate/src/features/auth/domain/entities/user.dart';

abstract class SplashState extends Equatable {
  const SplashState();

  @override
  List<Object?> get props => [];
}

class SplashInitial extends SplashState {
  const SplashInitial();
}

class SplashAuthenticated extends SplashState {
  final User user;

  const SplashAuthenticated(this.user);

  @override
  List<Object?> get props => [user];
}

class SplashUnauthenticated extends SplashState {
  const SplashUnauthenticated();
}
