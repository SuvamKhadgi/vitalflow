import 'package:equatable/equatable.dart';

class AuthEntity extends Equatable {
  final String? userId;
  final String name;
  final String email;
  final String password;
  final String? image;

  const AuthEntity({
    this.userId,
    required this.email,
    required this.password,
    required this.name,
    this.image,
  });
  @override
  List<Object?> get props => [userId, name, email, password, image];
}
