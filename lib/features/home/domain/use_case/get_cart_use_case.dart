import 'package:dartz/dartz.dart';
import 'package:vitalflow/app/usecase/usecase.dart';
import 'package:vitalflow/core/error/failure.dart';
import 'package:vitalflow/features/home/data/repository/cart_repository.dart';
import 'package:vitalflow/features/home/domain/entity/cart_entity.dart';
// import 'package:vitalflow/features/home/domain/repository/cart_repository.dart';

class GetCartParams {
  final String userId;

  const GetCartParams({required this.userId});
}

class GetCartUseCase implements UsecaseWithParams<CartEntity, GetCartParams> {
  final ICartRepository repository;

  GetCartUseCase(this.repository);

  @override
  Future<Either<Failure, CartEntity>> call(GetCartParams params) {
    return repository.getCartByUserId(params.userId);
  }
}