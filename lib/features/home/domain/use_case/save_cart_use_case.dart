import 'package:dartz/dartz.dart';
import 'package:vitalflow/app/usecase/usecase.dart';
import 'package:vitalflow/core/error/failure.dart';
import 'package:vitalflow/features/home/data/repository/cart_repository.dart';
import 'package:vitalflow/features/home/domain/entity/cart_entity.dart';

class SaveCartParams {
  final String userId;
  final List<Map<String, dynamic>> items;

  const SaveCartParams({required this.userId, required this.items});
}

class SaveCartUseCase implements UsecaseWithParams<CartEntity, SaveCartParams> {
  final ICartRepository repository;

  SaveCartUseCase(this.repository);

  @override
  Future<Either<Failure, CartEntity>> call(SaveCartParams params) {
    return repository.saveCart(params.userId, params.items);
  }
}
