import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:vitalflow/app/usecase/usecase.dart';
import 'package:vitalflow/core/error/failure.dart';
import 'package:vitalflow/features/auth/domain/entity/auth_entity.dart';
import 'package:vitalflow/features/auth/domain/repository/auth_repoitory.dart';

class SignupUserParams extends Equatable {
  final String name;
  final String email;
  final String password;

  const SignupUserParams({
    required this.name,
    required this.email,
    required this.password,
  });

  const SignupUserParams.initial({
    required this.email,
    required this.password,
    required this.name,
  });
  @override
  List<Object> get props => [email, password, name];
}

class SignupUsecase implements UsecaseWithParams<void, SignupUserParams> {
  final IAuthRepoitory repoitory;

  SignupUsecase(this.repoitory);
  @override
  Future<Either<Failure, void>> call(SignupUserParams params) {
    final authEntity = AuthEntity(
      name: params.name,
      email: params.email,
      password: params.password,
    );
    return repoitory.signupUser(authEntity);
  }
}
