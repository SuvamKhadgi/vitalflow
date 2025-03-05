part of 'orders_bloc.dart';

class OrdersState extends Equatable {
  final List<OrderEntity> orders;
  final bool isLoading;
  final String? error;

  const OrdersState({
    required this.orders,
    required this.isLoading,
    this.error,
  });

  const OrdersState.initial()
      : orders = const [],
        isLoading = false,
        error = null;

  OrdersState copyWith({
    List<OrderEntity>? orders,
    bool? isLoading,
    String? error,
  }) {
    return OrdersState(
      orders: orders ?? this.orders,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [orders, isLoading, error];
}