import 'package:equatable/equatable.dart';
import 'package:hajjmate/src/features/auth/domain/entities/user.dart';

abstract class SignUpState extends Equatable {
  const SignUpState();

  @override
  List<Object?> get props => [];
}

class SignUpInitial extends SignUpState {
  const SignUpInitial();
}

class SignUpSubmitting extends SignUpState {
  const SignUpSubmitting();
}

class SignUpSuccess extends SignUpState {
  final User user;

  const SignUpSuccess(this.user);

  @override
  List<Object?> get props => [user];
}

class SignUpFailure extends SignUpState {
  final String message;

  const SignUpFailure(this.message);

  @override
  List<Object?> get props => [message];
}
