import 'package:equatable/equatable.dart';
import 'package:hajjmate/src/features/auth/domain/entities/role.dart';

class SignUpParams extends Equatable {
  final String name;
  final String phone;
  final String email;
  final String password;
  final Role role;

  const SignUpParams({
    required this.name,
    required this.phone,
    required this.email,
    required this.password,
    required this.role,
  });

  @override
  List<Object?> get props => [name, phone, email, password, role];
}
