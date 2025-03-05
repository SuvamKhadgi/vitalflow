import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:vitalflow/core/error/failure.dart';
import 'package:vitalflow/features/home/domain/entity/item_entity.dart';
import 'package:vitalflow/features/home/domain/repository/item_repository.dart';
import 'package:vitalflow/features/home/domain/use_case/get_items_usecase.dart';

// Define a concrete mock class
class MockItemRepository extends Mock implements IItemRepository {
  @override
  Future<Either<Failure, List<ItemEntity>>> getItems() async {
    return super.noSuchMethod(
      Invocation.method(#getItems, []),
      returnValue: Future<Either<Failure, List<ItemEntity>>>.value(Right([])),
      returnValueForMissingStub:
          Future<Either<Failure, List<ItemEntity>>>.value(Right([])),
    );
  }
}

void main() {
  late GetItemsUseCase usecase;
  late MockItemRepository mockItemRepository;

  setUp(() {
    mockItemRepository = MockItemRepository();
    usecase = GetItemsUseCase(mockItemRepository);
  });

  final tItems = [
    ItemEntity(
        id: '1',
        name: 'Item 1',
        description: 'h',
        price: 1,
        quantity: 1,
        type: 'h',
        subType: 'h',
        image: 'jhg'),
    ItemEntity(
        id: '2',
        name: 'Item 2',
        description: 'h',
        price: 1,
        quantity: 1,
        type: 'h',
        subType: 'h',
        image: 'jhg'),
  ];

  test('should get all items from the repository', () async {
    // arrange
    when(mockItemRepository.getItems()).thenAnswer((_) async {
      return Right<Failure, List<ItemEntity>>(tItems);
    });

    // act
    final result = await usecase();

    // assert
    expect(result, Right(tItems));
    verify(mockItemRepository.getItems());
    verifyNoMoreInteractions(mockItemRepository);
  });

  test(
      'should return a Failure when getting the items is unsuccessful',
      () async {
    // arrange
    when(mockItemRepository.getItems()).thenAnswer((_) async {
      return Left<Failure, List<ItemEntity>>(ApiFailure(message: ''));
    });

    // act
    final result = await usecase();

    // assert
    expect(result, Left(ApiFailure(message: '')));
    verify(mockItemRepository.getItems());
    verifyNoMoreInteractions(mockItemRepository);
  });
}
