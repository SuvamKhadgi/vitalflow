import 'package:dio/dio.dart';
import 'package:vitalflow/app/constants/api_endpoints.dart';
import 'package:vitalflow/core/common/internet_checker/internet_checker.dart';
import 'package:vitalflow/core/network/hive_service.dart';
import 'package:vitalflow/features/home/data/dto/cart_dto.dart';
import 'package:vitalflow/features/home/data/model/cart_hive_model.dart';

abstract class ICartRemoteDataSource {
  Future<List<CartDto>> getAllCarts();
  Future<CartDto> saveCart(String userId, List<Map<String, dynamic>> items);
  Future<CartDto> getCartByUserId(String userId);
  Future<void> deleteCart(String cartId);
  Future<CartDto> updateCart(String cartId, Map<String, dynamic> data);
  Future<CartDto> getCartById(String cartId);
  Future<CartDto> deleteCartItem(String cartId, String itemId); // Add this line
}

class CartRemoteDataSource implements ICartRemoteDataSource {
  final Dio dio;
  final HiveService hiveService;

  CartRemoteDataSource(this.dio, this.hiveService);

  @override
  Future<List<CartDto>> getAllCarts() async {
    final hasInternet = await InternetChecker.hasInternet();
    if (hasInternet) {
      try {
        final response = await dio.get(ApiEndpoints.cart);
        final carts = (response.data as List)
            .map((json) => CartDto.fromJson(json))
            .toList();
        return carts;
      } on DioException catch (e) {
        throw Exception('Network error: $e');
      }
    } else {
      throw Exception('No internet connection');
    }
  }

  @override
  Future<CartDto> saveCart(
      String userId, List<Map<String, dynamic>> items) async {
    final hasInternet = await InternetChecker.hasInternet();
    if (hasInternet) {
      try {
        final response = await dio.post(
          ApiEndpoints.cart,
          data: {'userId': userId, 'items': items},
        );
        final cart = CartDto.fromJson(response.data);
        await hiveService.saveCart(CartHiveModel.fromEntity(cart.toEntity()));
        return cart;
      } on DioException catch (e) {
        throw Exception('Network error: $e');
      }
    } else {
      throw Exception('No internet connection');
    }
  }

  @override
  Future<CartDto> getCartByUserId(String userId) async {
    final hasInternet = await InternetChecker.hasInternet();
    if (hasInternet) {
      try {
        final response = await dio.get('${ApiEndpoints.cartByUserId}/$userId');
        if (response.statusCode == 200) {
          if (response.data.isEmpty) {
            return CartDto(id: null, userId: userId, items: []);
          }
          final cart = CartDto.fromJson(response.data[0]);
          await hiveService.saveCart(CartHiveModel.fromEntity(cart.toEntity()));
          return cart;
        } else if (response.statusCode == 404) {
          return CartDto(id: null, userId: userId, items: []);
        } else {
          throw Exception('Failed to load cart: ${response.statusMessage}');
        }
      } on DioException catch (e) {
        if (e.response?.statusCode == 404) {
          return CartDto(id: null, userId: userId, items: []);
        }
        throw Exception('Network error: $e');
      }
    } else {
      final hiveCart = await hiveService.getCart(userId);
      return hiveCart != null
          ? CartDto.fromJson(hiveCart.toEntity().toJson())
          : CartDto(id: null, userId: userId, items: []);
    }
  }

  @override
  Future<void> deleteCart(String cartId) async {
    final hasInternet = await InternetChecker.hasInternet();
    if (hasInternet) {
      try {
        await dio.delete('${ApiEndpoints.cartById}/$cartId');
      } on DioException catch (e) {
        throw Exception('Network error: $e');
      }
    } else {
      throw Exception('No internet connection');
    }
  }

Future<CartDto> deleteCartItem(String cartId, String itemId) async {
  final hasInternet = await InternetChecker.hasInternet();
  if (hasInternet) {
    if (cartId == null) {
      print('Cart ID is null, cannot delete item via API');
      throw Exception('Cart ID is null');
    }
    try {
      final response = await dio.delete(
        '${ApiEndpoints.cartById}/$cartId/item/$itemId',
      );
      if (response.statusCode == 200) {
        print('API response after delete: ${response.data}');
        // Extract the 'cart' object from the response
        final cartData = response.data['cart'] as Map<String, dynamic>;
        final cart = CartDto.fromJson(cartData);
        await hiveService.saveCart(CartHiveModel.fromEntity(cart.toEntity()));
        return cart;
      } else {
        throw Exception('Failed to delete item from cart: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      throw Exception('Network error: $e');
    }
  } else {
    final userId = cartId.split('/').last;
    final currentCart = await hiveService.getCart(userId) ??
        CartHiveModel(id: cartId, userId: userId, items: []);
    if (currentCart.id == null) {
      print('No cart exists offline to delete item from');
      return CartDto.fromJson(currentCart.toEntity().toJson());
    }
    final updatedItems = List<CartItemHiveModel>.from(currentCart.items)
      ..removeWhere((item) => item.itemId == itemId);
    final updatedCart = CartHiveModel(
      id: currentCart.id,
      userId: currentCart.userId,
      items: updatedItems,
    );
    await hiveService.saveCart(updatedCart);
    print('Offline: Item $itemId removed, updated cart has ${updatedCart.items.length} items');
    return CartDto.fromJson(updatedCart.toEntity().toJson());
  }
}
  @override
  Future<CartDto> updateCart(String cartId, Map<String, dynamic> data) async {
    final hasInternet = await InternetChecker.hasInternet();
    if (hasInternet) {
      try {
        final response =
            await dio.put('${ApiEndpoints.cartById}/$cartId', data: data);
        final cart = CartDto.fromJson(response.data);
        await hiveService.saveCart(CartHiveModel.fromEntity(cart.toEntity()));
        return cart;
      } on DioException catch (e) {
        throw Exception('Network error: $e');
      }
    } else {
      throw Exception('No internet connection');
    }
  }

  @override
  Future<CartDto> getCartById(String cartId) async {
    final hasInternet = await InternetChecker.hasInternet();
    if (hasInternet) {
      try {
        final response = await dio.get('${ApiEndpoints.cartById}/$cartId');
        return CartDto.fromJson(response.data);
      } on DioException catch (e) {
        throw Exception('Network error: $e');
      }
    } else {
      throw Exception('No internet connection');
    }
  }
}
