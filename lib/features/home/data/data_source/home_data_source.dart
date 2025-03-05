import 'package:vitalflow/features/home/data/dto/item_dto.dart';

abstract class IRemoteDataSource {
  Future<List<ItemDto>> getItems();
}