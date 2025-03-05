import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vitalflow/app/di/di.dart';
import 'package:vitalflow/features/home/domain/entity/cart_entity.dart';
import 'package:vitalflow/features/home/domain/entity/item_entity.dart';
import 'package:vitalflow/features/home/presentation/view/cart_view.dart';
import 'package:vitalflow/features/home/presentation/view_model/bloc/orders_bloc.dart';
import 'package:vitalflow/features/home/presentation/view_model/home_bloc.dart';
import 'package:vitalflow/features/home/presentation/view_model/home_state.dart';

// Mocks
class MockHomeBloc extends MockBloc<HomeEvent, HomeState> implements HomeBloc {}

class MockOrdersBloc extends MockBloc<OrdersEvent, OrdersState>
    implements OrdersBloc {}

// Mock CachedNetworkImage
class MockCachedNetworkImage extends StatelessWidget {
  final String imageUrl;
  final double width;
  final double height;
  final BoxFit fit;

  const MockCachedNetworkImage({
    super.key,
    required this.imageUrl,
    required this.width,
    required this.height,
    required this.fit,
  });

  @override
  Widget build(BuildContext context) {
    // Replace with a simple placeholder widget
    return Container(
      width: width,
      height: height,
      color: Colors.grey, // Placeholder color
      child: const Center(child: Icon(Icons.image)),
    );
  }
}

void main() {
  setUpAll(() {
    // Register mocks for dependency injection
    getIt.registerFactory<OrdersBloc>(() => MockOrdersBloc());
  });

  tearDownAll(() {
    getIt.reset();
  });

  group('CartView Widget Tests', () {
    late MockHomeBloc mockHomeBloc;

    setUp(() {
      mockHomeBloc = MockHomeBloc();
      registerFallbackValue(const HomeState(
        isLoading: false,
        error: null,
        dashboardItems: [],
        cart: null,
        userId: null,
        selectedIndex: 0, // Provide a default value
        views: [], // Provide an empty list of widgets
      ));
    });

    tearDown(() {
      mockHomeBloc.close();
    });

    testWidgets(
        'CartView displays "Your cart is empty" message when cart is null or empty',
        (WidgetTester tester) async {
      // Arrange
      when(() => mockHomeBloc.state).thenReturn(const HomeState(
        isLoading: false,
        error: null,
        dashboardItems: [],
        cart: null,
        userId: 'testUserId',
        selectedIndex: 0, // Provide a default value
        views: [], // Provide an empty list of widgets
      ));

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<HomeBloc>(
            create: (context) => mockHomeBloc,
            child: const CartView(),
          ),
        ),
      );

      // Assert
      expect(find.text('Your cart is empty'), findsOneWidget);
    });

    testWidgets('CartView displays cart items when available',
        (WidgetTester tester) async {
      // Arrange
      final items = [
        ItemEntity(
          id: '1',
          name: 'Test Item 1',
          description: 'Description 1',
          price: 10.0,
          quantity: 5,
          image: 'image1.jpg',
          type: 'Category 1',
          subType: 'rfgsr',
        ),
        ItemEntity(
          id: '2',
          name: 'Test Item 2',
          description: 'Description 2',
          price: 20.0,
          quantity: 10,
          image: 'image2.jpg',
          type: 'Category 2',
          subType: 'sfgf',
        ),
      ];

      final cartItems = [
        const CartItemEntity(itemId: '1', quantity: 2),
        const CartItemEntity(itemId: '2', quantity: 1),
      ];

      final cart = CartEntity(id: 'cart1', items: cartItems, userId: '1');

      when(() => mockHomeBloc.state).thenReturn(HomeState(
        isLoading: false,
        error: null,
        dashboardItems: items,
        cart: cart,
        userId: 'testUserId',
        selectedIndex: 0, // Provide a default value
        views: const [], // Provide an empty list of widgets
      ));

      // Override CachedNetworkImage
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<HomeBloc>(
            create: (context) => mockHomeBloc,
            child: Builder(builder: (context) {
              return const MediaQuery(
                data: MediaQueryData(),
                child: CartView(),
              );
            }),
          ),
        ),
      );

      // Assert
      expect(find.text('Test Item 1'), findsOneWidget);
      expect(find.text('Test Item 2'), findsOneWidget);
      expect(find.byType(ListTile), findsNWidgets(2));
    });

    testWidgets(
        'CartView displays "Order Now" button when cart and user ID are available',
        (WidgetTester tester) async {
      // Arrange
      final items = [
        ItemEntity(
          id: '1',
          name: 'Test Item 1',
          description: 'Description 1',
          price: 10.0,
          quantity: 5,
          image: 'image1.jpg',
          type: 'Category 1',
          subType: 'rfgsr',
        ),
      ];

      final cartItems = [const CartItemEntity(itemId: '1', quantity: 2)];
      final cart = CartEntity(id: 'cart1', items: cartItems, userId: '1');

      when(() => mockHomeBloc.state).thenReturn(HomeState(
        isLoading: false,
        error: null,
        dashboardItems: items,
        cart: cart,
        userId: 'testUserId',
        selectedIndex: 0, // Provide a default value
        views: const [], // Provide an empty list of widgets
      ));

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<HomeBloc>(
            create: (context) => mockHomeBloc,
            child: const CartView(),
          ),
        ),
      );

      // Assert
      expect(find.text('Order Now'), findsOneWidget);
    });

    testWidgets(
        'CartView does not display "Order Now" button when cart or user ID is missing',
        (WidgetTester tester) async {
      // Arrange: No cart
      when(() => mockHomeBloc.state).thenReturn(const HomeState(
        isLoading: false,
        error: null,
        dashboardItems: [],
        cart: null,
        userId: 'testUserId',
        selectedIndex: 0, // Provide a default value
        views: [], // Provide an empty list of widgets
      ));

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<HomeBloc>(
            create: (context) => mockHomeBloc,
            child: const CartView(),
          ),
        ),
      );

      // Assert
      expect(find.text('Order Now'), findsNothing);

      // Arrange: No user ID
      when(() => mockHomeBloc.state).thenReturn(const HomeState(
        isLoading: false,
        error: null,
        dashboardItems: [],
        cart: CartEntity(id: 'cart1', items: [], userId: '1'),
        userId: null,
        selectedIndex: 0, // Provide a default value
        views: [], // Provide an empty list of widgets
      ));

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<HomeBloc>(
            create: (context) => mockHomeBloc,
            child: const CartView(),
          ),
        ),
      );

      // Assert
      expect(find.text('Order Now'), findsNothing);
    });

    testWidgets('CartView shows loading indicator when isLoading is true',
        (WidgetTester tester) async {
      // Arrange
      when(() => mockHomeBloc.state).thenReturn(const HomeState(
        isLoading: true,
        error: null,
        dashboardItems: [],
        cart: null,
        userId: null,
        selectedIndex: 0, // Provide a default value
        views: [], // Provide an empty list of widgets
      ));

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<HomeBloc>(
            create: (context) => mockHomeBloc,
            child: const CartView(),
          ),
        ),
      );

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('CartView shows error message when error is not null',
        (WidgetTester tester) async {
      // Arrange
      const errorMessage = 'An error occurred';
      when(() => mockHomeBloc.state).thenReturn(const HomeState(
        isLoading: false,
        error: errorMessage,
        dashboardItems: [],
        cart: null,
        userId: null,
        selectedIndex: 0, // Provide a default value
        views: [], // Provide an empty list of widgets
      ));

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<HomeBloc>(
            create: (context) => mockHomeBloc,
            child: const CartView(),
          ),
        ),
      );

      // Assert
      expect(find.text('Error: $errorMessage'), findsOneWidget);
    });
  });
}
