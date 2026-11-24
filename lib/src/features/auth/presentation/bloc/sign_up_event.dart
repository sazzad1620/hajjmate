import 'package:equatable/equatable.dart';
import 'package:hajjmate/src/features/auth/domain/entities/sign_up_params.dart';

abstract class SignUpEvent extends Equatable {
  const SignUpEvent();

  @override
  List<Object?> get props => [];
}

class SignUpSubmitted extends SignUpEvent {
  final SignUpParams params;

  const SignUpSubmitted(this.params);

  @override
  List<Object?> get props => [params];
}
