import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:vitalflow/core/error/failure.dart';
import 'package:vitalflow/features/home/data/repository/cart_repository.dart';
import 'package:vitalflow/features/home/domain/entity/cart_entity.dart';
import 'package:vitalflow/features/home/domain/use_case/get_cart_use_case.dart';

// Generate mocks with Mockito
import 'get_cart_use_case_test.mocks.dart';

@GenerateMocks([ICartRepository])
void main() {
  late GetCartUseCase useCase;
  late MockICartRepository mockRepository;

  setUp(() {
    mockRepository = MockICartRepository();
    useCase = GetCartUseCase(mockRepository);
  });

  group('GetCartUseCase', () {
    // Sample data for testing
    const userId = 'user1';
    const params = GetCartParams(userId: userId);
    const cartEntity = CartEntity(
      id: 'cart1',
      userId: userId,
      items: [
        // {'itemId': 'item1', 'quantity': 2}
      ],
    );

    test('should return Right with CartEntity when repository succeeds',
        () async {
      // Arrange
      when(mockRepository.getCartByUserId(userId))
          .thenAnswer((_) async => const Right(cartEntity));

      // Act
      final result = await useCase.call(params);

      // Assert
      expect(result, equals(const Right<Failure, CartEntity>(cartEntity)));
      verify(mockRepository.getCartByUserId(userId)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return Left with Failure when repository fails', () async {
      // Arrange
      const failure = ApiFailure(message: 'Cart not found');
      when(mockRepository.getCartByUserId(userId))
          .thenAnswer((_) async => const Left(failure));

      // Act
      final result = await useCase.call(params);

      // Assert
      expect(result, equals(const Left<Failure, CartEntity>(failure)));
      verify(mockRepository.getCartByUserId(userId)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
