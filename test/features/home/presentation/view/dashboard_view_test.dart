import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart'; // Ensure mocktail is imported
import 'package:vitalflow/features/home/presentation/view/dashboard_view.dart';
import 'package:vitalflow/features/home/presentation/view_model/home_bloc.dart';
import 'package:vitalflow/features/home/presentation/view_model/home_state.dart';

class MockHomeBloc extends MockBloc<HomeEvent, HomeState> implements HomeBloc {
  @override
  Stream<HomeState> mapEventToState(HomeEvent event) async* {
    print('MockHomeBloc received event: $event'); // Log the event
    yield state; // Just yield the current state for testing purposes
  }
}

// Test-specific version of DashboardView that uses Image.asset
class TestDashboardView extends StatelessWidget {
  const TestDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state.dashboardItems == null || state.dashboardItems!.isEmpty) {
            return const Center(child: Text('No items'));
          }

          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
            itemCount: state.dashboardItems!.length,
            itemBuilder: (context, index) {
              final item = state.dashboardItems![index];
              return Card(
                child: Column(
                  children: [
                    Expanded(
                      child: Image.asset(
                        'assets/test_image.png', // Use a local asset
                        fit: BoxFit.cover,
                      ),
                    ),
                    Text(item.name),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

void main() {
  group('DashboardView widget test', () {
    late MockHomeBloc mockHomeBloc;

    setUp(() {
      mockHomeBloc = MockHomeBloc();
      // Register a fallback value for HomeState
      registerFallbackValue(const HomeState(
        selectedIndex: 0,
        views: [],
        dashboardItems: [],
      ));
    });

    tearDown(() {
      mockHomeBloc.close();
    });

    testWidgets('DashboardView renders correctly', (WidgetTester tester) async {
      // Define the state you want the bloc to emit.  Provide the required 'views' parameter.
      when(() => mockHomeBloc.state).thenAnswer((_) => const HomeState(
            selectedIndex: 0, // Provide a default value
            views: [], // Provide an empty list of widgets
            dashboardItems: [], // Provide an empty list of items
          ));

      // Build our widget and trigger a frame.  Wrap the DashboardView with a BlocProvider.
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<HomeBloc>(
            create: (context) => mockHomeBloc,
            child: const DashboardView(),
          ),
        ),
      );

      // Verify that the DashboardView is rendered.
      expect(find.byType(DashboardView), findsOneWidget);

      // Verify that the AppBar with the title 'Dashboard' is present.
      expect(find.text('Dashboard'), findsOneWidget);

      // Verify that the search TextField is present.
      expect(find.byType(TextField), findsOneWidget);
    });
  });
}
