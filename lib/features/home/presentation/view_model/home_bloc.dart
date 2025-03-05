import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:vitalflow/app/di/di.dart';
import 'package:vitalflow/app/shared_prefs/token_shared_prefs.dart';
import 'package:vitalflow/core/common/snackbar/my_snackbar.dart';
import 'package:vitalflow/features/home/domain/entity/cart_entity.dart';
import 'package:vitalflow/features/home/domain/use_case/delete_cart_item_use_case.dart';
import 'package:vitalflow/features/home/domain/use_case/get_cart_use_case.dart';
import 'package:vitalflow/features/home/domain/use_case/get_items_usecase.dart';
import 'package:vitalflow/features/home/domain/use_case/save_cart_use_case.dart';
import 'package:vitalflow/features/home/presentation/view_model/home_state.dart';

class HomeEvent {}

class TabTapped extends HomeEvent {
  final int index;
  TabTapped(this.index);
}

class FetchDashboardItems extends HomeEvent {}

class FetchCart extends HomeEvent {}

class AddToCart extends HomeEvent {
  final String itemId;
  final int quantity;
  AddToCart(this.itemId, this.quantity);
}

class RemoveFromCart extends HomeEvent {
  final String itemId;
  final BuildContext context; // Add context
  RemoveFromCart(this.itemId, this.context);
}

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetItemsUseCase getItemsUseCase;
  final GetCartUseCase getCartUseCase;
  final SaveCartUseCase saveCartUseCase;
  final DeleteCartItemUseCase deleteCartItemUseCase; // New use case
  String? userId;

  HomeBloc(
    this.getItemsUseCase,
    this.getCartUseCase,
    this.saveCartUseCase,
    this.deleteCartItemUseCase,
  ) : super(HomeState.initial()) {
    on<TabTapped>(
        (event, emit) => emit(state.copyWith(selectedIndex: event.index)));
    on<FetchDashboardItems>((event, emit) => _fetchItems(event, emit, null));
    on<FetchCart>(_fetchCart);
    on<AddToCart>(_addToCart);
    on<RemoveFromCart>(_removeFromCart);
    _initializeUserId();
  }

  Future<void> _initializeUserId() async {
    final tokenResult = await getIt<TokenSharedPrefs>().getToken();
    tokenResult.fold(
      (failure) => add(FetchDashboardItems()),
      (token) {
        final payload = Jwt.parseJwt(token);
        userId = payload['userId']?.toString();
        emit(state.copyWith(userId: userId));
        add(FetchDashboardItems());
        add(FetchCart());
      },
    );
  }

  Future<void> _fetchItems(FetchDashboardItems event, Emitter<HomeState> emit,
      BuildContext? context) async {
    emit(state.copyWith(isLoading: true));
    final result = await getItemsUseCase();
    result.fold(
      (failure) {
        emit(state.copyWith(isLoading: false, error: failure.message));
        if (context != null && failure.message.contains('No internet')) {
          showMySnackBar(
              context: context,
              message: 'No Internet Connection',
              color: Colors.red);
        }
      },
      (items) => emit(
          state.copyWith(isLoading: false, dashboardItems: items, error: null)),
    );
  }

  Future<void> _fetchCart(FetchCart event, Emitter<HomeState> emit) async {
    if (state.userId == null) return;
    emit(state.copyWith(isLoading: true));
    final result = await getCartUseCase(GetCartParams(userId: state.userId!));
    result.fold(
      (failure) => emit(state.copyWith(
          isLoading: false,
          cart: CartEntity(userId: state.userId!, items: const []))),
      (cart) => emit(state.copyWith(isLoading: false, cart: cart, error: null)),
    );
  }

  Future<void> _addToCart(AddToCart event, Emitter<HomeState> emit) async {
    if (state.userId == null) return;
    emit(state.copyWith(isLoading: true));
    final currentCart =
        state.cart ?? CartEntity(userId: state.userId!, items: const []);
    final updatedItems = List<CartItemEntity>.from(currentCart.items);
    final itemIndex =
        updatedItems.indexWhere((item) => item.itemId == event.itemId);

    if (itemIndex >= 0) {
      updatedItems[itemIndex] = CartItemEntity(
        itemId: event.itemId,
        quantity: updatedItems[itemIndex].quantity + event.quantity,
      );
    } else {
      updatedItems
          .add(CartItemEntity(itemId: event.itemId, quantity: event.quantity));
    }

    final result = await saveCartUseCase(SaveCartParams(
      userId: state.userId!,
      items: updatedItems
          .map((item) => {'itemId': item.itemId, 'quantity': item.quantity})
          .toList(),
    ));

    result.fold(
      (failure) =>
          emit(state.copyWith(isLoading: false, error: failure.message)),
      (cart) => emit(state.copyWith(isLoading: false, cart: cart, error: null)),
    );
  }

  Future<void> _removeFromCart(
      RemoveFromCart event, Emitter<HomeState> emit) async {
    if (state.userId == null) {
      print('Cannot remove item: userId is null');
      return;
    }
    if (state.cart == null || state.cart!.id == null) {
      print('Cart or cart ID is null, skipping deletion');
      emit(state.copyWith(isLoading: false, error: 'Cart not initialized'));
      return;
    }
    emit(state.copyWith(isLoading: true));
    print('Removing item: cartId=${state.cart!.id}, itemId=${event.itemId}');
    final result = await deleteCartItemUseCase(DeleteCartItemParams(
      cartId: state.cart!.id!,
      itemId: event.itemId,
    ));
    result.fold(
      (failure) {
        print('Failed to remove item: ${failure.message}');
        emit(state.copyWith(isLoading: false, error: failure.message));
        showMySnackBar(
          context: event.context,
          message: 'Failed to delete item: ${failure.message}',
          color: Colors.red,
        );
      },
      (cart) {
        print('Item removed, updated cart: ${cart.items.length} items');
        emit(state.copyWith(isLoading: false, cart: cart, error: null));
        showMySnackBar(
          context: event.context,
          message: 'Item deleted successfully',
          color: Colors.green,
        );
      },
    );
  }
}
