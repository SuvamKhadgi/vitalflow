import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:vitalflow/features/auth/domain/entity/auth_entity.dart';

part 'auth_api_model.g.dart';

@JsonSerializable()
class AuthApiModel extends Equatable {
  @JsonKey(name: '_id')
  final String? id;
  final String name;
  final String email;
  final String? password;
  final String? image;

  const AuthApiModel({
    this.id,
    required this.email,
    required this.password,
    required this.name,
    required this.image,
  });

  factory AuthApiModel.fromJson(Map<String, dynamic> json) =>
      _$AuthApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$AuthApiModelToJson(this);

  // Convert to entity
  AuthEntity toEntity() {
    return AuthEntity(
        userId: id,
        name: name,
        email: email,
        password: password ?? '',
        image: image);
  }

  // Convert from entity
  factory AuthApiModel.fromEntity(AuthEntity entity) {
    return AuthApiModel(
      id: entity.userId,
      name: entity.name,
      email: entity.email,
      password: entity.password,
      image: entity.image,
    );
  }

  @override
  List<Object?> get props => [id, name, email, password, image];
}
