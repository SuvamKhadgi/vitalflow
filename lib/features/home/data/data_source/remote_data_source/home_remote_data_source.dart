import 'package:dio/dio.dart';
import 'package:vitalflow/app/constants/api_endpoints.dart';
import 'package:vitalflow/core/common/internet_checker/internet_checker.dart';
import 'package:vitalflow/core/network/hive_service.dart';
import 'package:vitalflow/features/home/data/data_source/home_data_source.dart';
import 'package:vitalflow/features/home/data/dto/item_dto.dart';
import 'package:vitalflow/features/home/data/model/item_hive_model.dart';

class RemoteDataSource implements IRemoteDataSource {
  final Dio dio;
  final HiveService hiveService;

  RemoteDataSource(this.dio, this.hiveService);

  @override
  Future<List<ItemDto>> getItems() async {
    final hasInternet = await InternetChecker.hasInternet();
    if (hasInternet) {
      try {
        final response = await dio.get(ApiEndpoints.items);
        if (response.statusCode == 200) {
          final List<dynamic> data = response.data;
          final items = data.map((json) => ItemDto.fromJson(json)).toList();
          // Save to Hive
          await hiveService.saveItems(
              items.map((item) => ItemHiveModel.fromEntity(item.toEntity())).toList());
          return items;
        } else {
          throw Exception('Failed to load items: ${response.statusMessage}');
        }
      } on DioException catch (e) {
        throw Exception('Network error: $e');
      }
    } else {
      final hiveItems = await hiveService.getItems();
      return hiveItems.map((item) => ItemDto.fromJson(item.toEntity().toJson())).toList();
    }
  }
}