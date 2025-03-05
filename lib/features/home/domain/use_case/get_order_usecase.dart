import 'package:dartz/dartz.dart';
import 'package:vitalflow/app/usecase/usecase.dart';
import 'package:vitalflow/core/error/failure.dart';
import 'package:vitalflow/features/home/domain/entity/order_entity.dart';
import 'package:vitalflow/features/home/domain/repository/order_repository.dart';

class GetOrdersUseCase implements UsecaseWithoutParams<List<OrderEntity>> {
  final IOrderRepository repository;

  GetOrdersUseCase(this.repository);

  @override
  Future<Either<Failure, List<OrderEntity>>> call() {
    return repository.getAllOrders();
  }
}