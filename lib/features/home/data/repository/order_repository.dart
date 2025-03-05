import 'package:dartz/dartz.dart';
import 'package:vitalflow/core/error/failure.dart';
import 'package:vitalflow/features/home/data/data_source/order_remote_data_source.dart';
import 'package:vitalflow/features/home/domain/entity/order_entity.dart';
import 'package:vitalflow/features/home/domain/repository/order_repository.dart';

class OrderRepository implements IOrderRepository {
  final IOrderRemoteDataSource remoteDataSource;

  OrderRepository(this.remoteDataSource);

  @override
  Future<Either<Failure, List<OrderEntity>>> getAllOrders() async {
    try {
      final ordersDto = await remoteDataSource.getAllOrders();
      final ordersEntity = ordersDto.map((dto) => dto.toEntity()).toList();
      return Right(ordersEntity);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, OrderEntity>> saveOrder(
      String userId, String address, String phoneNo, String cartId) async {
    try {
      final orderDto =
          await remoteDataSource.saveOrder(userId, address, phoneNo, cartId);
      return Right(orderDto.toEntity());
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }
}
