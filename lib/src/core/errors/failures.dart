import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;

  const Failure({required this.message});

  @override
  List<Object?> get props => [message];
}

class NetworkFailure extends Failure {
  const NetworkFailure({super.message = 'No internet connection.'});
}

class AuthFailure extends Failure {
  const AuthFailure({super.message = 'Authentication failed.'});
}

class PermissionFailure extends Failure {
  const PermissionFailure({super.message = 'Permission was denied.'});
}

class ValidationFailure extends Failure {
  const ValidationFailure({super.message = 'The data is not valid.'});
}

class ServerFailure extends Failure {
  const ServerFailure({super.message = 'Server error occurred.'});
}

class UnknownFailure extends Failure {
  const UnknownFailure({super.message = 'Something went wrong. Try again.'});
}
