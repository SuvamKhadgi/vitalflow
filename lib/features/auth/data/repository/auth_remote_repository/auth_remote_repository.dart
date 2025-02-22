import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:vitalflow/core/error/failure.dart';
import 'package:vitalflow/features/auth/data/data_source/remote_data_source.dart/auth_remote_datasource.dart';
import 'package:vitalflow/features/auth/domain/entity/auth_entity.dart';
import 'package:vitalflow/features/auth/domain/repository/auth_repoitory.dart';

class AuthRemoteRepository implements IAuthRepoitory {
  final AuthRemoteDataSource _authRemoteDatasource;
  AuthRemoteRepository(this._authRemoteDatasource);

  @override
  Future<Either<Failure, AuthEntity>> getCurrentUser() {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, String>> loginUser(
      String email, String password) async {
    try {
      final token = await _authRemoteDatasource.loginUser(email, password);
      return Right(token);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> signupUser(AuthEntity user) async {
    try {
      await _authRemoteDatasource.signupUser(user);
      return const Right(null);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> uploadProfilePicture(File file) async {
    try {
      final imageName = await _authRemoteDatasource.uploadProfilePicture(file);
      return Right(imageName);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
    // throw UnimplementedError();
  }
}
