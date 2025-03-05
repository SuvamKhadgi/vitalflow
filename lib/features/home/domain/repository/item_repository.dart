import 'package:dartz/dartz.dart';
import 'package:vitalflow/core/error/failure.dart';
import 'package:vitalflow/features/home/domain/entity/item_entity.dart';

abstract class IItemRepository {
  Future<Either<Failure, List<ItemEntity>>> getItems();
}