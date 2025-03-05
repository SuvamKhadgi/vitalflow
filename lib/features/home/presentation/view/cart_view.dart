import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vitalflow/app/constants/api_endpoints.dart';
import 'package:vitalflow/app/di/di.dart';
import 'package:vitalflow/core/common/snackbar/my_snackbar.dart';
import 'package:vitalflow/features/home/domain/entity/cart_entity.dart';
import 'package:vitalflow/features/home/domain/entity/item_entity.dart';
import 'package:vitalflow/features/home/presentation/view_model/bloc/orders_bloc.dart';
import 'package:vitalflow/features/home/presentation/view_model/home_bloc.dart';
import 'package:vitalflow/features/home/presentation/view_model/home_state.dart';

class CartView extends StatelessWidget {
  const CartView({super.key});

  void _showOrderDialog(BuildContext context, String userId, String cartId,
      List<CartItemEntity> items) {
    final theme = Theme.of(context);
    final TextEditingController addressController = TextEditingController();
    final TextEditingController phoneController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: theme.cardTheme.color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Confirm Order',
            style: TextStyle(
                fontWeight: FontWeight.bold, color: theme.primaryColor)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: addressController,
                decoration: InputDecoration(
                  labelText: 'Delivery Address',
                  labelStyle: theme.textTheme.bodyMedium,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: phoneController,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  labelStyle: theme.textTheme.bodyMedium,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                keyboardType: TextInputType.phone,
              ),
            ],
          ),
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          ElevatedButton(
            onPressed: () {
              final address = addressController.text.trim();
              final phoneNo = phoneController.text.trim();
              if (address.isNotEmpty && phoneNo.isNotEmpty) {
                print(
                    'Placing order: userId=$userId, cartId=$cartId, address=$address, phoneNo=$phoneNo');
                context.read<OrdersBloc>().add(SaveOrderEvent(
                      userId: userId,
                      address: address,
                      phoneNo: phoneNo,
                      cartId: cartId,
                    ));
                Navigator.pop(dialogContext);
                showMySnackBar(
                  context: context,
                  message: "Order Placed Successfully!",
                  color: Colors.green,
                  seconds: 3,
                );
                context
                    .read<HomeBloc>()
                    .emit(context.read<HomeBloc>().state.copyWith(cart: null));
              } else {
                showMySnackBar(
                  context: context,
                  message: "Please enter address and phone number",
                  color: Colors.red,
                  seconds: 2,
                );
              }
            },
            child: const Text('Place Order'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocProvider(
      create: (context) => getIt<OrdersBloc>(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Your Cart'),
          centerTitle: true,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [theme.primaryColor, const Color(0xFF03DAC6)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
        ),
        body: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            print(
                'CartView building: cart=${state.cart != null ? "id=${state.cart!.id}, items=${state.cart!.items.length}" : "null"}');
            if (state.isLoading)
              return const Center(child: CircularProgressIndicator());
            if (state.error != null) {
              return Center(
                  child: Text('Error: ${state.error}',
                      style: TextStyle(color: theme.colorScheme.error)));
            }
            if (state.cart == null || state.cart!.items.isEmpty) {
              print('Cart is null or empty: cart=${state.cart}');
              return Center(
                child: Text(
                  'Your cart is empty',
                  style: theme.textTheme.bodyLarge
                      ?.copyWith(color: theme.textTheme.bodyMedium?.color),
                ),
              );
            }

            final cartItems = state.cart!.items;
            print(
                'Cart items: ${cartItems.map((i) => "itemId=${i.itemId}, qty=${i.quantity}, type=${i.itemId.runtimeType}").toList()}');
            final dashboardItems = state.dashboardItems ?? [];
            if (dashboardItems.isEmpty) {
              return Center(
                  child: Text('No items loaded yet',
                      style: theme.textTheme.bodyLarge));
            }

            double totalPrice = cartItems.fold<double>(
              0,
              (sum, cartItem) {
                final item = dashboardItems.firstWhere(
                  (i) => i.id == cartItem.itemId,
                  orElse: () => ItemEntity(
                    id: cartItem.itemId,
                    name: 'Unknown Item',
                    description: 'Not available',
                    price: 0.0,
                    quantity: 0,
                    type: 'Unknown',
                    subType: 'Unknown',
                    image: '',
                  ),
                );
                return sum + (item.price * cartItem.quantity);
              },
            );

            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16).copyWith(
                        bottom:
                            120), // Increased padding for FAB and total price
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final cartItem = cartItems[index];
                      final item = dashboardItems.firstWhere(
                        (i) => i.id == cartItem.itemId,
                        orElse: () => ItemEntity(
                          id: cartItem.itemId,
                          name: 'Unknown Item',
                          description: 'Not available',
                          price: 0.0,
                          quantity: 0,
                          type: 'Unknown',
                          subType: 'Unknown',
                          image: '',
                        ),
                      );
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        elevation: 6,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        child: ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: CachedNetworkImage(
                              imageUrl:
                                  '${ApiEndpoints.itemImageUrl}${item.image}',
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                              placeholder: (context, url) =>
                                  const CircularProgressIndicator(),
                              errorWidget: (context, url, error) {
                                print(
                                    'Image load error: URL=$url, Error=$error');
                                return const Icon(Icons.error,
                                    color: Colors.red);
                              },
                            ),
                          ),
                          title: Text(item.name,
                              style: theme.textTheme.bodyLarge
                                  ?.copyWith(fontWeight: FontWeight.bold)),
                          subtitle: Text(
                            'Qty: ${cartItem.quantity} | Rs.${(item.price * cartItem.quantity).toStringAsFixed(2)}',
                            style: theme.textTheme.bodyMedium,
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              print('Deleting item: ${cartItem.itemId}');
                              context.read<HomeBloc>().add(
                                  RemoveFromCart(cartItem.itemId, context));
                            },
                          ),
                          contentPadding: const EdgeInsets.all(12),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  color: theme.brightness == Brightness.dark
                      ? Colors.grey[800]
                      : Colors.grey[100],
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total Price:',
                        style: theme.textTheme.bodyLarge
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Rs.${totalPrice.toStringAsFixed(2)}',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: theme.primaryColor),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
        floatingActionButton: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            print(
                'Rendering Order Now button: cart=${state.cart != null}, userId=${state.userId != null}, items=${state.cart?.items.length ?? 0}');
            return state.cart != null &&
                    state.userId != null &&
                    state.cart!.items.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.only(
                        bottom: 120), // Lift button higher
                    child: FloatingActionButton.extended(
                      onPressed: () => _showOrderDialog(context, state.userId!,
                          state.cart!.id!, state.cart!.items),
                      label: const Text('Order Now',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18)),
                      icon: const Icon(Icons.shopping_bag, size: 24),
                      // backgroundColor: theme.primarycolor,
                      elevation: 12,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                    ),
                  )
                : const SizedBox.shrink();
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }
}
