import 'package:equatable/equatable.dart';

abstract class SignOutState extends Equatable {
  const SignOutState();

  @override
  List<Object?> get props => [];
}

class SignOutInitial extends SignOutState {
  const SignOutInitial();
}

class SignOutSubmitting extends SignOutState {
  const SignOutSubmitting();
}

class SignOutSuccess extends SignOutState {
  const SignOutSuccess();
}

class SignOutFailure extends SignOutState {
  final String message;

  const SignOutFailure(this.message);

  @override
  List<Object?> get props => [message];
}
