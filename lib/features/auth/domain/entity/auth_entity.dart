import 'package:equatable/equatable.dart';

class AuthEntity extends Equatable {
  final String? userId;
  final String name;
  final String email;
  final String password;

  const AuthEntity({
    this.userId,
    required this.email,
    required this.password,
    required this.name,
  });
  @override
  List<Object?> get props => [userId, name, email, password];
}
