import 'package:dio/dio.dart';
import 'package:vitalflow/app/constants/api_endpoints.dart';
import 'package:vitalflow/core/common/internet_checker/internet_checker.dart';
import 'package:vitalflow/core/network/hive_service.dart';
import 'package:vitalflow/features/home/data/dto/order_dto.dart';
import 'package:vitalflow/features/home/data/model/order_hive_model.dart';

abstract class IOrderRemoteDataSource {
  Future<List<OrderDto>> getAllOrders();
  Future<OrderDto> saveOrder(String userId, String address, String phoneNo, String cartId); // Add this
}
class OrderRemoteDataSource implements IOrderRemoteDataSource {
  final Dio dio;
  final HiveService hiveService;

  OrderRemoteDataSource(this.dio, this.hiveService);

  @override
  Future<List<OrderDto>> getAllOrders() async {
    final hasInternet = await InternetChecker.hasInternet();
    if (hasInternet) {
      try {
        final response = await dio.get('${ApiEndpoints.baseUrl}order');
        if (response.statusCode == 200) {
          final List<dynamic> data = response.data;
          final orders = data.map((json) => OrderDto.fromJson(json)).toList();
          await hiveService.saveOrders(
              orders.map((order) => OrderHiveModel.fromEntity(order.toEntity())).toList());
          return orders;
        } else if (response.statusCode == 404) {
          return [];
        } else {
          throw Exception('Failed to load orders: ${response.statusMessage}');
        }
      } on DioException catch (e) {
        throw Exception('Network error: $e');
      }
    } else {
      final hiveOrders = await hiveService.getOrders();
      return hiveOrders.map((order) => OrderDto.fromJson(order.toEntity().toJson())).toList();
    }
  }

  @override
  Future<OrderDto> saveOrder(String userId, String address, String phoneNo, String cartId) async {
    final hasInternet = await InternetChecker.hasInternet();
    if (hasInternet) {
      try {
        final response = await dio.post(
          '${ApiEndpoints.baseUrl}order',
          data: {
            'userId': userId,
            'address': address,
            'phone_no': phoneNo,
            'cartId': cartId,
          },
        );
        if (response.statusCode == 201) {
          final order = OrderDto.fromJson(response.data);
          await hiveService.saveOrders([OrderHiveModel.fromEntity(order.toEntity())]);
          return order;
        } else {
          throw Exception('Failed to save order: ${response.statusMessage}');
        }
      } on DioException catch (e) {
        throw Exception('Network error: $e');
      }
    } else {
      throw Exception('No internet connection');
    }
  }
}