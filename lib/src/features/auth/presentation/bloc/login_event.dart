import 'package:equatable/equatable.dart';
import 'package:hajjmate/src/features/auth/domain/entities/login_params.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object?> get props => [];
}

class LoginSubmitted extends LoginEvent {
  final LoginParams params;

  const LoginSubmitted(this.params);

  @override
  List<Object?> get props => [params];
}
