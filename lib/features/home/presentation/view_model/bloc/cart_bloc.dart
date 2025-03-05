import 'package:bloc/bloc.dart';
import 'package:vitalflow/app/di/di.dart';
import 'package:vitalflow/app/shared_prefs/token_shared_prefs.dart';
import 'package:vitalflow/features/home/domain/entity/cart_entity.dart';
import 'package:vitalflow/features/home/domain/use_case/get_cart_use_case.dart';
import 'package:vitalflow/features/home/domain/use_case/save_cart_use_case.dart';
import 'package:vitalflow/features/home/presentation/view_model/bloc/cart_event.dart';
import 'package:vitalflow/features/home/presentation/view_model/bloc/cart_state.dart';
import 'package:jwt_decode/jwt_decode.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final GetCartUseCase getCartUseCase;
  final SaveCartUseCase saveCartUseCase;
  late String userId;

  CartBloc(this.getCartUseCase, this.saveCartUseCase) : super(CartInitial()) {
    _initializeUserId();
    on<FetchCartEvent>(_onFetchCart);
    on<IncreaseQuantity>(_onIncreaseQuantity);
    on<DecreaseQuantity>(_onDecreaseQuantity);
  }

  Future<void> _initializeUserId() async {
    final tokenResult = await getIt<TokenSharedPrefs>().getToken();
    tokenResult.fold(
      (failure) => print('Token retrieval failed: ${failure.message}'),
      (token) {
        final payload = Jwt.parseJwt(token);
        userId = payload['userId']?.toString() ?? '';
        add(FetchCartEvent());
      },
    );
  }

  Future<void> _onFetchCart(FetchCartEvent event, Emitter<CartState> emit) async {
    emit(CartLoading());
    final result = await getCartUseCase(GetCartParams(userId: userId));
    result.fold(
      (failure) => emit(CartError(failure.message)),
      (cart) => emit(CartLoaded(cart)),
    );
  }

  Future<void> _onIncreaseQuantity(IncreaseQuantity event, Emitter<CartState> emit) async {
    if (state is CartLoaded) {
      final currentCart = (state as CartLoaded).cart;
      final updatedItems = List<CartItemEntity>.from(currentCart.items);
      final itemIndex = updatedItems.indexWhere((item) => item.itemId == event.itemId);

      if (itemIndex >= 0) {
        updatedItems[itemIndex] = CartItemEntity(
          itemId: event.itemId,
          quantity: updatedItems[itemIndex].quantity + 1,
        );
      }

      final result = await saveCartUseCase(SaveCartParams(
        userId: userId,
        items: updatedItems.map((item) => {'itemId': item.itemId, 'quantity': item.quantity}).toList(),
      ));

      result.fold(
        (failure) => emit(CartError(failure.message)),
        (cart) => emit(CartLoaded(cart)),
      );
    }
  }

  Future<void> _onDecreaseQuantity(DecreaseQuantity event, Emitter<CartState> emit) async {
    if (state is CartLoaded) {
      final currentCart = (state as CartLoaded).cart;
      final updatedItems = List<CartItemEntity>.from(currentCart.items);
      final itemIndex = updatedItems.indexWhere((item) => item.itemId == event.itemId);

      if (itemIndex >= 0 && updatedItems[itemIndex].quantity > 1) {
        updatedItems[itemIndex] = CartItemEntity(
          itemId: event.itemId,
          quantity: updatedItems[itemIndex].quantity - 1,
        );
      } else if (itemIndex >= 0) {
        updatedItems.removeAt(itemIndex);
      }

      final result = await saveCartUseCase(SaveCartParams(
        userId: userId,
        items: updatedItems.map((item) => {'itemId': item.itemId, 'quantity': item.quantity}).toList(),
      ));

      result.fold(
        (failure) => emit(CartError(failure.message)),
        (cart) => emit(CartLoaded(cart)),
      );
    }
  }
}