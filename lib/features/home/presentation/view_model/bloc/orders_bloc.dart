import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:vitalflow/features/home/domain/entity/order_entity.dart';
import 'package:vitalflow/features/home/domain/use_case/get_order_usecase.dart';
import 'package:vitalflow/features/home/domain/use_case/save_order_use_case.dart';

part 'orders_event.dart';
part 'orders_state.dart';

class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  final GetOrdersUseCase getOrdersUseCase;
final SaveOrderUseCase saveOrderUseCase;
  OrdersBloc(this.getOrdersUseCase, this.saveOrderUseCase) : super(const OrdersState.initial()) {
    on<FetchOrdersEvent>(_fetchOrders);
    on<SaveOrderEvent>(_saveOrder);
  }

 Future<void> _fetchOrders(FetchOrdersEvent event, Emitter<OrdersState> emit) async {
  print('Fetching orders...'); // Debug
  emit(state.copyWith(isLoading: true));
  final result = await getOrdersUseCase();
  result.fold(
    (failure) {
      print('Orders fetch failed: ${failure.message}');
      emit(state.copyWith(isLoading: false, error: failure.message));
    },
    (orders) {
      print('Orders fetched: ${orders.length}'); // Debug
      emit(state.copyWith(isLoading: false, orders: orders, error: null));
    },
  );
}
Future<void> _saveOrder(SaveOrderEvent event, Emitter<OrdersState> emit) async {
    print('Saving order...');
    emit(state.copyWith(isLoading: true));
    final result = await saveOrderUseCase(SaveOrderParams(
      userId: event.userId,
      address: event.address,
      phoneNo: event.phoneNo,
      cartId: event.cartId,
    ));
    result.fold(
      (failure) {
        print('Save order failed: ${failure.message}');
        emit(state.copyWith(isLoading: false, error: failure.message));
      },
      (order) {
        print('Order saved: ${order.id}');
        emit(state.copyWith(isLoading: false, orders: [...state.orders, order], error: null));
        emit(state.copyWith(isLoading: false)); // Trigger refresh
      },
    );
  }
}

class SaveOrderEvent extends OrdersEvent {
  final String userId;
  final String address;
  final String phoneNo;
  final String cartId;

  const SaveOrderEvent({required this.userId, required this.address, required this.phoneNo, required this.cartId});
}