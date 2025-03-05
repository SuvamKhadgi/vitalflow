import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:vitalflow/features/home/domain/entity/item_entity.dart';
import 'package:vitalflow/features/home/domain/use_case/get_items_usecase.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final GetItemsUseCase getItemsUseCase;

  DashboardBloc(this.getItemsUseCase) : super(DashboardInitial()) {
    on<FetchItemsEvent>(_onFetchItems);
  }

  Future<void> _onFetchItems(
    FetchItemsEvent event,
    Emitter<DashboardState> emit,
  ) async {
    emit(DashboardLoading());
    final result = await getItemsUseCase();
    result.fold(
      (failure) => emit(DashboardError(failure.message)),
      (items) => emit(DashboardLoaded(items)),
    );
  }
}