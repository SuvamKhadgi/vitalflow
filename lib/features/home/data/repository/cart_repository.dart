import 'package:dartz/dartz.dart';
import 'package:vitalflow/core/error/failure.dart';
import 'package:vitalflow/features/home/data/data_source/cart_remote_data_source.dart';
import 'package:vitalflow/features/home/domain/entity/cart_entity.dart';

abstract class ICartRepository {
  Future<Either<Failure, List<CartEntity>>> getAllCarts();
  Future<Either<Failure, CartEntity>> saveCart(
      String userId, List<Map<String, dynamic>> items);
  Future<Either<Failure, CartEntity>> getCartByUserId(String userId);
  Future<Either<Failure, void>> deleteCart(String cartId);
  Future<Either<Failure, CartEntity>> updateCart(
      String cartId, Map<String, dynamic> data);
  Future<Either<Failure, CartEntity>> getCartById(String cartId);
  Future<Either<Failure, CartEntity>> deleteCartItem(
      String cartId, String itemId); // New method
}

class CartRepository implements ICartRepository {
  final ICartRemoteDataSource remoteDataSource;

  CartRepository(this.remoteDataSource);

  @override
  Future<Either<Failure, List<CartEntity>>> getAllCarts() async {
    try {
      final cartsDto = await remoteDataSource.getAllCarts();
      final cartsEntity = cartsDto.map((dto) => dto.toEntity()).toList();
      return Right(cartsEntity);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, CartEntity>> saveCart(
      String userId, List<Map<String, dynamic>> items) async {
    try {
      final cartDto = await remoteDataSource.saveCart(userId, items);
      return Right(cartDto.toEntity());
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, CartEntity>> getCartByUserId(String userId) async {
    try {
      final cartDto = await remoteDataSource.getCartByUserId(userId);
      return Right(cartDto.toEntity());
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteCart(String cartId) async {
    try {
      await remoteDataSource.deleteCart(cartId);
      return const Right(null);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, CartEntity>> updateCart(
      String cartId, Map<String, dynamic> data) async {
    try {
      final cartDto = await remoteDataSource.updateCart(cartId, data);
      return Right(cartDto.toEntity());
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, CartEntity>> getCartById(String cartId) async {
    try {
      final cartDto = await remoteDataSource.getCartById(cartId);
      return Right(cartDto.toEntity());
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, CartEntity>> deleteCartItem(
      String cartId, String itemId) async {
    try {
      final cartDto = await remoteDataSource.deleteCartItem(cartId, itemId);
      return Right(cartDto.toEntity());
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }
}
