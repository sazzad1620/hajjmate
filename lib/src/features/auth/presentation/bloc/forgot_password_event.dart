import 'package:equatable/equatable.dart';
import 'package:hajjmate/src/features/auth/domain/entities/forgot_password_params.dart';

abstract class ForgotPasswordEvent extends Equatable {
  const ForgotPasswordEvent();

  @override
  List<Object?> get props => [];
}

class ForgotPasswordSubmitted extends ForgotPasswordEvent {
  final ForgotPasswordParams params;

  const ForgotPasswordSubmitted(this.params);

  @override
  List<Object?> get props => [params];
}
