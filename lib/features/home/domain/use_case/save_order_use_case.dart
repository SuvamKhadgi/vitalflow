import 'package:dartz/dartz.dart';
import 'package:vitalflow/app/usecase/usecase.dart';
import 'package:vitalflow/core/error/failure.dart';
import 'package:vitalflow/features/home/domain/entity/order_entity.dart';
import 'package:vitalflow/features/home/domain/repository/order_repository.dart';

class SaveOrderParams {
  final String userId;
  final String address;
  final String phoneNo;
  final String cartId;

  const SaveOrderParams({
    required this.userId,
    required this.address,
    required this.phoneNo,
    required this.cartId,
  });
}

class SaveOrderUseCase implements UsecaseWithParams<OrderEntity, SaveOrderParams> {
  final IOrderRepository repository;

  SaveOrderUseCase(this.repository);

  @override
  Future<Either<Failure, OrderEntity>> call(SaveOrderParams params) {
    return repository.saveOrder(params.userId, params.address, params.phoneNo, params.cartId);
  }
}