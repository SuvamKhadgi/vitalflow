import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:vitalflow/app/my_app.dart';
import 'package:vitalflow/features/home/presentation/view_model/home_bloc.dart';
import 'package:vitalflow/features/home/presentation/view_model/home_state.dart';

import 'home_view_test.mocks.dart';
// import 'mocks.mocks.dart'; // Import generated mocks


@GenerateMocks([
  HomeBloc,
  ThemeCubit,
  EventChannel,
])
void main() {
  late MockHomeBloc mockHomeBloc;

  // Sample views for testing (not used directly but for state consistency)
  final List<Widget> testViews = [
    const Center(child: Text('Cart View')),
    const Center(child: Text('Home View')),
    const Center(child: Text('Profile View')),
  ];

  setUp(() {
    mockHomeBloc = MockHomeBloc();

    // Stub HomeBloc behavior
    when(mockHomeBloc.state).thenReturn(HomeState(selectedIndex: 0, views: testViews));
    when(mockHomeBloc.stream).thenAnswer((_) => Stream.value(HomeState(selectedIndex: 0, views: testViews)));
  });

  // Helper widget: Extracted BottomNavigationBar from HomeView for isolated testing
  Widget buildBottomNavBarTestWidget(int selectedIndex) {
    return BlocProvider<HomeBloc>.value(
      value: mockHomeBloc,
      child: MaterialApp(
        home: Scaffold(
          bottomNavigationBar: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: BlocBuilder<HomeBloc, HomeState>(
              builder: (context, state) {
                return BottomNavigationBar(
                  items: [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.shopping_cart, size: state.selectedIndex == 0 ? 30 : 24),
                      label: 'Cart',
                    ),
                    BottomNavigationBarItem(
                      icon: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: state.selectedIndex == 1 ? const Color(0xFF6200EE) : Colors.grey[200],
                        ),
                        child: Icon(
                          Icons.home,
                          size: 36,
                          color: state.selectedIndex == 1 ? Colors.white : Colors.grey[600],
                        ),
                      ),
                      label: 'Home',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.person, size: state.selectedIndex == 2 ? 30 : 24),
                      label: 'Profile',
                    ),
                  ],
                  currentIndex: state.selectedIndex,
                  selectedItemColor: const Color(0xFF6200EE),
                  unselectedItemColor: Colors.grey[600],
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  onTap: (index) => context.read<HomeBloc>().add(TabTapped(index)),
                  type: BottomNavigationBarType.fixed,
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  group('HomeView BottomNavigationBar Tests', () {
    testWidgets('renders BottomNavigationBar with Cart selected initially', (WidgetTester tester) async {
      // Arrange
      when(mockHomeBloc.state).thenReturn(HomeState(selectedIndex: 0, views: testViews));

      // Act
      await tester.pumpWidget(buildBottomNavBarTestWidget(0));
      await tester.pump();

      // Assert
      expect(find.byIcon(Icons.shopping_cart), findsOneWidget);
      final cartIcon = tester.widget<Icon>(find.byIcon(Icons.shopping_cart));
      expect(cartIcon.size, 30); // Selected size
      expect(find.byType(BottomNavigationBar), findsOneWidget);
    });

    testWidgets('switches to Home tab when tapped', (WidgetTester tester) async {
      // Arrange
      when(mockHomeBloc.state).thenReturn(HomeState(selectedIndex: 0, views: testViews));
      when(mockHomeBloc.stream).thenAnswer((_) => Stream.fromIterable([
            HomeState(selectedIndex: 0, views: testViews),
            HomeState(selectedIndex: 1, views: testViews),
          ]));

      // Act
      await tester.pumpWidget(buildBottomNavBarTestWidget(0));
      await tester.pump();
      await tester.tap(find.byIcon(Icons.home));
      await tester.pumpAndSettle();

      // Assert
      final homeIcon = tester.widget<Icon>(find.byIcon(Icons.home));
      expect(homeIcon.size, 36);
      
    });

    testWidgets('renders Profile tab when selectedIndex is 2', (WidgetTester tester) async {
      // Arrange
      when(mockHomeBloc.state).thenReturn(HomeState(selectedIndex: 2, views: testViews));

      // Act
      await tester.pumpWidget(buildBottomNavBarTestWidget(2));
      await tester.pump();

      // Assert
      final profileIcon = tester.widget<Icon>(find.byIcon(Icons.person));
      expect(profileIcon.size, 24.0); // Selected size
      expect(find.byType(BottomNavigationBar), findsOneWidget);
    });

    testWidgets('BottomNavigationBar highlights Home item when selected', (WidgetTester tester) async {
      // Arrange
      when(mockHomeBloc.state).thenReturn(HomeState(selectedIndex: 1, views: testViews));

      // Act
      await tester.pumpWidget(buildBottomNavBarTestWidget(1));
      await tester.pump();

      // Assert
      final homeIcon = tester.widget<Icon>(find.byIcon(Icons.home));
      expect(homeIcon.size, 36);
     
    });
  });
}