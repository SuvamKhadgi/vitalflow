import 'package:dartz/dartz.dart';
import 'package:vitalflow/core/error/failure.dart';
import 'package:vitalflow/features/home/domain/entity/order_entity.dart';

abstract class IOrderRepository {
  Future<Either<Failure, List<OrderEntity>>> getAllOrders();
  Future<Either<Failure, OrderEntity>> saveOrder(String userId, String address, String phoneNo, String cartId);
}