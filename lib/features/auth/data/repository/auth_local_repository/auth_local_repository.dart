import 'package:dartz/dartz.dart';
import 'package:vitalflow/core/error/failure.dart';
import 'package:vitalflow/features/auth/data/data_source/local_datasource.dart/auth_local_datasource.dart';
import 'package:vitalflow/features/auth/domain/entity/auth_entity.dart';
import 'package:vitalflow/features/auth/domain/repository/auth_repoitory.dart';

class AuthLocalRepository implements IAuthRepoitory {
  final AuthLocalDataSource _authLocalDataSource;

  AuthLocalRepository(this._authLocalDataSource);

  @override
  Future<Either<Failure, AuthEntity>> getCurrentUser() async {
    try {
      final currentUser = await _authLocalDataSource.getCurrentUser();
      return Right(currentUser);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> loginUser(
    String email,
    String password,
  ) async {
    try {
      final token = await _authLocalDataSource.loginUser(email, password);
      return Right(token);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> signupUser(AuthEntity user) async {
    try {
      return Right(_authLocalDataSource.signupUser(user));
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  // @override
  // Future<Either<Failure, String>> uploadProfilePicture(File file) async {
  //   throw UnimplementedError();
  // }
}
