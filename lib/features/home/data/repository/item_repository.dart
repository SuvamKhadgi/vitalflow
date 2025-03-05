import 'package:dartz/dartz.dart';
import 'package:vitalflow/core/error/failure.dart';
import 'package:vitalflow/features/home/data/data_source/home_data_source.dart';
import 'package:vitalflow/features/home/domain/entity/item_entity.dart';
import 'package:vitalflow/features/home/domain/repository/item_repository.dart';

class ItemRepository implements IItemRepository {
  final IRemoteDataSource remoteDataSource;

  ItemRepository(this.remoteDataSource);
  @override
  Future<Either<Failure, List<ItemEntity>>> getItems() async {
    try {
      final itemsDto = await remoteDataSource.getItems();
      final itemsEntity = itemsDto.map((dto) => dto.toEntity()).toList();
      return Right(itemsEntity);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }
}
