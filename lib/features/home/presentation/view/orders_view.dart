import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vitalflow/features/home/presentation/view_model/bloc/orders_bloc.dart';

class OrdersView extends StatelessWidget {
  const OrdersView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Orders')),
      body: BlocBuilder<OrdersBloc, OrdersState>(
        builder: (context, state) {
          print('OrdersView building: orders=${state.orders.length}, isLoading=${state.isLoading}, error=${state.error}');
          if (state.isLoading) return const Center(child: CircularProgressIndicator());
          if (state.error != null) return Center(child: Text('Error: ${state.error}'));
          if (state.orders.isEmpty) return const Center(child: Text('No orders yet'));
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: state.orders.length,
            itemBuilder: (context, index) {
              final order = state.orders[index];
              return ListTile(
                title: Text('Order #${order.id}'),
                subtitle: Text('Address: ${order.address}'),
                trailing: Text(order.createdAt.toString().substring(0, 10)),
              );
            },
          );
        },
      ),
    );
  }
}