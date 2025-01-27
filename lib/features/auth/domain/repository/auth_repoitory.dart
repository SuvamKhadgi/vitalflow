import 'package:dartz/dartz.dart';
import 'package:vitalflow/core/error/failure.dart';
import 'package:vitalflow/features/auth/domain/entity/auth_entity.dart';

abstract interface class IAuthRepoitory {
  Future<Either<Failure, void>> signupUser(AuthEntity user);
  Future<Either<Failure, String>> loginUser(String email, String password);
  Future<Either<Failure, AuthEntity>> getCurrentUser();
}
