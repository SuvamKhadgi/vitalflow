import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:vitalflow/core/error/failure.dart';
import 'package:vitalflow/features/home/data/data_source/cart_remote_data_source.dart';
import 'package:vitalflow/features/home/data/dto/cart_dto.dart';
import 'package:vitalflow/features/home/data/repository/cart_repository.dart';
import 'package:vitalflow/features/home/domain/entity/cart_entity.dart';

// Generate mocks with Mockito
import 'cart_repository_test.mocks.dart';

@GenerateMocks([ICartRemoteDataSource])
void main() {
  late CartRepository cartRepository;
  late MockICartRemoteDataSource mockRemoteDataSource;

  setUp(() {
    mockRemoteDataSource = MockICartRemoteDataSource();
    cartRepository = CartRepository(mockRemoteDataSource);
  });

  group('CartRepository', () {
    // Sample data for testing
    final cartDto = CartDto(id: '1', userId: 'user1', items: [
      // {'itemId': 'item1', 'quantity': 2}
    ]);
    final cartEntity = cartDto.toEntity();
    final cartDtoList = [
      cartDto,
      CartDto(id: '2', userId: 'user2', items: [
        // {'itemId': 'item2', 'quantity': 1}
      ])
    ];
    final cartEntityList = cartDtoList.map((dto) => dto.toEntity()).toList();

    // Test for getAllCarts


    test('getAllCarts should return Left with ApiFailure when it fails',
        () async {
      // Arrange
      when(mockRemoteDataSource.getAllCarts())
          .thenThrow(Exception('Fetch error'));

      // Act
      final result = await cartRepository.getAllCarts();

      // Assert
      expect(
          result,
          equals(const Left<Failure, List<CartEntity>>(
              ApiFailure(message: 'Exception: Fetch error'))));
      verify(mockRemoteDataSource.getAllCarts()).called(1);
    });

    // Test for saveCart
    test('saveCart should return Right with CartEntity when successful',
        () async {
      // Arrange
      const userId = 'user1';
      final items = [
        {'itemId': 'item1', 'quantity': 2}
      ];
      when(mockRemoteDataSource.saveCart(userId, items))
          .thenAnswer((_) async => cartDto);

      // Act
      final result = await cartRepository.saveCart(userId, items);

      // Assert
      expect(result, equals(Right<Failure, CartEntity>(cartEntity)));
      verify(mockRemoteDataSource.saveCart(userId, items)).called(1);
    });

    test('saveCart should return Left with ApiFailure when it fails', () async {
      // Arrange
      const userId = 'user1';
      final items = [
        {'itemId': 'item1', 'quantity': 2}
      ];
      when(mockRemoteDataSource.saveCart(userId, items))
          .thenThrow(Exception('Save error'));

      // Act
      final result = await cartRepository.saveCart(userId, items);

      // Assert
      expect(
          result,
          equals(const Left<Failure, CartEntity>(
              ApiFailure(message: 'Exception: Save error'))));
      verify(mockRemoteDataSource.saveCart(userId, items)).called(1);
    });

    // Test for getCartByUserId
    test('getCartByUserId should return Right with CartEntity when successful',
        () async {
      // Arrange
      const userId = 'user1';
      when(mockRemoteDataSource.getCartByUserId(userId))
          .thenAnswer((_) async => cartDto);

      // Act
      final result = await cartRepository.getCartByUserId(userId);

      // Assert
      expect(result, equals(Right<Failure, CartEntity>(cartEntity)));
      verify(mockRemoteDataSource.getCartByUserId(userId)).called(1);
    });

    test('getCartByUserId should return Left with ApiFailure when it fails',
        () async {
      // Arrange
      const userId = 'user1';
      when(mockRemoteDataSource.getCartByUserId(userId))
          .thenThrow(Exception('Fetch error'));

      // Act
      final result = await cartRepository.getCartByUserId(userId);

      // Assert
      expect(
          result,
          equals(const Left<Failure, CartEntity>(
              ApiFailure(message: 'Exception: Fetch error'))));
      verify(mockRemoteDataSource.getCartByUserId(userId)).called(1);
    });

    // Test for deleteCart
    test('deleteCart should return Right with null when successful', () async {
      // Arrange
      const cartId = '1';
      when(mockRemoteDataSource.deleteCart(cartId)).thenAnswer((_) async {});

      // Act
      final result = await cartRepository.deleteCart(cartId);

      // Assert
      expect(result, equals(const Right<Failure, void>(null)));
      verify(mockRemoteDataSource.deleteCart(cartId)).called(1);
    });

    test('deleteCart should return Left with ApiFailure when it fails',
        () async {
      // Arrange
      const cartId = '1';
      when(mockRemoteDataSource.deleteCart(cartId))
          .thenThrow(Exception('Delete error'));

      // Act
      final result = await cartRepository.deleteCart(cartId);

      // Assert
      expect(
          result,
          equals(const Left<Failure, void>(
              ApiFailure(message: 'Exception: Delete error'))));
      verify(mockRemoteDataSource.deleteCart(cartId)).called(1);
    });

    // Test for updateCart
    test('updateCart should return Right with CartEntity when successful',
        () async {
      // Arrange
      const cartId = '1';
      final data = {
        'items': [
          {'itemId': 'item1', 'quantity': 3}
        ]
      };
      when(mockRemoteDataSource.updateCart(cartId, data))
          .thenAnswer((_) async => cartDto);

      // Act
      final result = await cartRepository.updateCart(cartId, data);

      // Assert
      expect(result, equals(Right<Failure, CartEntity>(cartEntity)));
      verify(mockRemoteDataSource.updateCart(cartId, data)).called(1);
    });

    // Test for getCartById
    test('getCartById should return Right with CartEntity when successful',
        () async {
      // Arrange
      const cartId = '1';
      when(mockRemoteDataSource.getCartById(cartId))
          .thenAnswer((_) async => cartDto);

      // Act
      final result = await cartRepository.getCartById(cartId);

      // Assert
      expect(result, equals(Right<Failure, CartEntity>(cartEntity)));
      verify(mockRemoteDataSource.getCartById(cartId)).called(1);
    });

    // Test for deleteCartItem
    test('deleteCartItem should return Right with CartEntity when successful',
        () async {
      // Arrange
      const cartId = '1';
      const itemId = 'item1';
      when(mockRemoteDataSource.deleteCartItem(cartId, itemId))
          .thenAnswer((_) async => cartDto);

      // Act
      final result = await cartRepository.deleteCartItem(cartId, itemId);

      // Assert
      expect(result, equals(Right<Failure, CartEntity>(cartEntity)));
      verify(mockRemoteDataSource.deleteCartItem(cartId, itemId)).called(1);
    });
  });
}
