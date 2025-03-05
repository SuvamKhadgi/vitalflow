import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:vitalflow/core/error/failure.dart';
import 'package:vitalflow/features/home/data/repository/cart_repository.dart';
import 'package:vitalflow/features/home/domain/entity/cart_entity.dart';
import 'package:vitalflow/features/home/domain/use_case/delete_cart_item_use_case.dart';
// import 'package:vitalflow/features/home/domain/use_case/delete_cart_item_usecase.dart';

// Generate mocks with Mockito
import 'delete_cart_item_use_case_test.mocks.dart';

@GenerateMocks([ICartRepository])
void main() {
  late DeleteCartItemUseCase useCase;
  late MockICartRepository mockRepository;

  setUp(() {
    mockRepository = MockICartRepository();
    useCase = DeleteCartItemUseCase(mockRepository);
  });

  group('DeleteCartItemUseCase', () {
    // Sample data for testing
    const cartId = 'cart1';
    const itemId = 'item1';
    const params = DeleteCartItemParams(cartId: cartId, itemId: itemId);
    const cartEntity = CartEntity(id: cartId, userId: 'user1', items: [
      // {'itemId': 'item2', 'quantity': 1}
    ]);

    test('should return Right with CartEntity when repository succeeds',
        () async {
      // Arrange
      when(mockRepository.deleteCartItem(cartId, itemId))
          .thenAnswer((_) async => const Right(cartEntity));

      // Act
      final result = await useCase.call(params);

      // Assert
      expect(result, equals(const Right<Failure, CartEntity>(cartEntity)));
      verify(mockRepository.deleteCartItem(cartId, itemId)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return Left with Failure when repository fails', () async {
      // Arrange
      const failure = ApiFailure(message: 'Item deletion failed');
      when(mockRepository.deleteCartItem(cartId, itemId))
          .thenAnswer((_) async => const Left(failure));

      // Act
      final result = await useCase.call(params);

      // Assert
      expect(result, equals(const Left<Failure, CartEntity>(failure)));
      verify(mockRepository.deleteCartItem(cartId, itemId)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
