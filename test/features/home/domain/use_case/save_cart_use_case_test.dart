import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:vitalflow/core/error/failure.dart';
import 'package:vitalflow/features/home/data/repository/cart_repository.dart';
import 'package:vitalflow/features/home/domain/entity/cart_entity.dart';
import 'package:vitalflow/features/home/domain/use_case/save_cart_use_case.dart';

// Generate mocks with Mockito
import 'save_cart_use_case_test.mocks.dart';

@GenerateMocks([ICartRepository])
void main() {
  late SaveCartUseCase useCase;
  late MockICartRepository mockRepository;

  setUp(() {
    mockRepository = MockICartRepository();
    useCase = SaveCartUseCase(mockRepository);
  });

  group('SaveCartUseCase', () {
    // Sample data for testing
    const userId = 'user1';
    final items = [
      // {'itemId': 'item1', 'quantity': 2},
      {'itemId': 'item2', 'quantity': 1},
    ];
    final params = SaveCartParams(userId: userId, items: items);
    const cartEntity = CartEntity(
      id: 'cart1',
      userId: userId,
      items: [],
    );

    test('should return Right with CartEntity when repository succeeds',
        () async {
      // Arrange
      when(mockRepository.saveCart(userId, items))
          .thenAnswer((_) async => const Right(cartEntity));

      // Act
      final result = await useCase.call(params);

      // Assert
      expect(result, equals(const Right<Failure, CartEntity>(cartEntity)));
      verify(mockRepository.saveCart(userId, items)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return Left with Failure when repository fails', () async {
      // Arrange
      const failure = ApiFailure(message: 'Failed to save cart');
      when(mockRepository.saveCart(userId, items))
          .thenAnswer((_) async => const Left(failure));

      // Act
      final result = await useCase.call(params);

      // Assert
      expect(result, equals(const Left<Failure, CartEntity>(failure)));
      verify(mockRepository.saveCart(userId, items)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
