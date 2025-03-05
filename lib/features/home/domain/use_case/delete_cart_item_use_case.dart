import 'package:dartz/dartz.dart';
import 'package:vitalflow/app/usecase/usecase.dart';
import 'package:vitalflow/core/error/failure.dart';
import 'package:vitalflow/features/home/data/repository/cart_repository.dart';
import 'package:vitalflow/features/home/domain/entity/cart_entity.dart';

class DeleteCartItemParams {
  final String cartId;
  final String itemId;

  const DeleteCartItemParams({required this.cartId, required this.itemId});
}

class DeleteCartItemUseCase implements UsecaseWithParams<CartEntity, DeleteCartItemParams> {
  final ICartRepository repository;

  DeleteCartItemUseCase(this.repository);

  @override
  Future<Either<Failure, CartEntity>> call(DeleteCartItemParams params) {
    return repository.deleteCartItem(params.cartId, params.itemId);
  }
}