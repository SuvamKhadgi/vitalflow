import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:vitalflow/core/error/failure.dart';
import 'package:vitalflow/features/home/data/data_source/home_data_source.dart';
import 'package:vitalflow/features/home/data/dto/item_dto.dart';
import 'package:vitalflow/features/home/data/repository/item_repository.dart';
import 'package:vitalflow/features/home/domain/entity/item_entity.dart';

// Generate mocks with Mockito
import 'item_repository_test.mocks.dart';

@GenerateMocks([IRemoteDataSource])
void main() {
  late ItemRepository itemRepository;
  late MockIRemoteDataSource mockRemoteDataSource;

  setUp(() {
    mockRemoteDataSource = MockIRemoteDataSource();
    itemRepository = ItemRepository(mockRemoteDataSource);
  });

  group('ItemRepository - getItems', () {
    // Sample data for testing
    final itemDtoList = [
      ItemDto(
         
          name: 'Item 1',
          price: 10.0, description: '', quantity: 1, type: 'a', subType: 'a', image: '', id: '1'), // Assuming ItemDto has these fields
      ItemDto(id: '2', name: 'Item 2', price: 20.0, description: 'a', quantity: 5, type: 's', subType: 's', image: ''),

    ];
    final itemEntityList = itemDtoList.map((dto) => dto.toEntity()).toList();

    test(
        'should return Right with List<ItemEntity> when remoteDataSource succeeds',
        () async {
      // Arrange
      when(mockRemoteDataSource.getItems())
          .thenAnswer((_) async => itemDtoList);

      // Act
      final result = await itemRepository.getItems();

      // Assert
      // expect(result, Right(itemEntityList));
      equals(Right<Failure, List<ItemEntity>>(itemEntityList));
      verify(mockRemoteDataSource.getItems()).called(1);
      verifyNoMoreInteractions(mockRemoteDataSource);
    });

    test(
        'should return Left with ApiFailure when remoteDataSource throws an exception',
        () async {
      // Arrange
      const errorMessage = 'Network error';
      when(mockRemoteDataSource.getItems()).thenThrow(Exception(errorMessage));

      // Act
      final result = await itemRepository.getItems();

      // Assert
      expect(
          result, const Left(ApiFailure(message: 'Exception: $errorMessage')));
      verify(mockRemoteDataSource.getItems()).called(1);
      verifyNoMoreInteractions(mockRemoteDataSource);
    });
  });
}
