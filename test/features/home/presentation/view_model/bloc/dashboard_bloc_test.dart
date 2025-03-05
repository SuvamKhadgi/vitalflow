import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:vitalflow/core/error/failure.dart';
import 'package:vitalflow/features/home/domain/entity/item_entity.dart';
import 'package:vitalflow/features/home/domain/use_case/get_items_usecase.dart';
import 'package:vitalflow/features/home/presentation/view_model/bloc/dashboard_bloc.dart';

// Generate mocks with Mockito
import 'dashboard_bloc_test.mocks.dart';

@GenerateMocks([GetItemsUseCase])
void main() {
  late DashboardBloc dashboardBloc;
  late MockGetItemsUseCase mockGetItemsUseCase;

  setUp(() {
    mockGetItemsUseCase = MockGetItemsUseCase();
    dashboardBloc = DashboardBloc(mockGetItemsUseCase);
  });

  tearDown(() {
    dashboardBloc.close();
  });

  group('DashboardBloc', () {
    // Sample data for testing
    final items = [
      ItemEntity(
          id: '1', name: 'a', description: 's', price: 1, quantity: 1, type: 's', subType: 's', image: '',
        ),
    ];

    test('initial state is DashboardInitial', () {
      expect(dashboardBloc.state, DashboardInitial());
    });

    blocTest<DashboardBloc, DashboardState>(
      'emits [DashboardLoading, DashboardLoaded] when FetchItemsEvent is added and use case succeeds',
      build: () {
        when(mockGetItemsUseCase()).thenAnswer((_) async => Right(items));
        return dashboardBloc;
      },
      act: (bloc) => bloc.add(FetchItemsEvent()),
      expect: () => [
        DashboardLoading(),
        DashboardLoaded(items),
      ],
      verify: (_) {
        verify(mockGetItemsUseCase()).called(1);
      },
    );

    blocTest<DashboardBloc, DashboardState>(
      'emits [DashboardLoading, DashboardError] when FetchItemsEvent is added and use case fails',
      build: () {
        when(mockGetItemsUseCase()).thenAnswer((_) async =>
            const Left(ApiFailure(message: 'Failed to fetch items')));
        return dashboardBloc;
      },
      act: (bloc) => bloc.add(FetchItemsEvent()),
      expect: () => [
        DashboardLoading(),
        const DashboardError('Failed to fetch items'),
      ],
      verify: (_) {
        verify(mockGetItemsUseCase()).called(1);
      },
    );
  });
}
