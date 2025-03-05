import 'package:dartz/dartz.dart';
import 'package:vitalflow/app/usecase/usecase.dart';
import 'package:vitalflow/core/error/failure.dart';
import 'package:vitalflow/features/home/domain/entity/item_entity.dart';
import 'package:vitalflow/features/home/domain/repository/item_repository.dart';
// import 'package:vitalflow/features/home/data/repository/item_repository.dart';

class GetItemsParams {}

class GetItemsUseCase implements UsecaseWithoutParams<List<ItemEntity>> {
  final IItemRepository repository;

  GetItemsUseCase(this.repository);

  @override
  Future<Either<Failure, List<ItemEntity>>> call() {
    return repository.getItems();
  }
}