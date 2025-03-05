import 'package:equatable/equatable.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:uuid/uuid.dart';
import 'package:vitalflow/app/constants/hive_table_constant.dart';
import 'package:vitalflow/features/auth/domain/entity/auth_entity.dart';

part 'auth_hive_model.g.dart';

@HiveType(typeId: 0)
class AuthHiveModel extends Equatable {
  @HiveField(0)
  final String? usersId;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String email;
  @HiveField(3)
  final String password;

  AuthHiveModel({
    String? usersId,
    required this.name,
    required this.email,
    required this.password,
  }) : usersId = usersId ?? const Uuid().v4();

  const AuthHiveModel.initial()
      : usersId = '',
        name = '',
        email = '',
        password = '';

  factory AuthHiveModel.fromEnity(AuthEntity entity) {
    return AuthHiveModel(
      usersId: entity.userId,
      name: entity.name,
      email: entity.email,
      password: entity.password,
    );
  }

  AuthEntity toEntity() {
    return AuthEntity(
        userId: usersId, name: name, email: email, password: password);
  }

  @override
  List<Object?> get props => [usersId, name, email, password];
}
