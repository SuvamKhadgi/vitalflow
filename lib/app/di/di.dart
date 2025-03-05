import 'dart:async';

import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vitalflow/app/shared_prefs/token_shared_prefs.dart';
import 'package:vitalflow/core/network/api_service.dart';
import 'package:vitalflow/core/network/hive_service.dart';
import 'package:vitalflow/features/auth/data/data_source/local_datasource.dart/auth_local_datasource.dart';
import 'package:vitalflow/features/auth/data/data_source/remote_data_source.dart/auth_remote_datasource.dart';
import 'package:vitalflow/features/auth/data/repository/auth_local_repository/auth_local_repository.dart';
import 'package:vitalflow/features/auth/data/repository/auth_remote_repository/auth_remote_repository.dart';
import 'package:vitalflow/features/auth/domain/use_case/login_usecase.dart';
import 'package:vitalflow/features/auth/domain/use_case/signup_usecase.dart';
import 'package:vitalflow/features/auth/domain/use_case/upload_image_usecase.dart';
import 'package:vitalflow/features/auth/presentation/view_model/login/login_bloc.dart';
import 'package:vitalflow/features/auth/presentation/view_model/signup/signup_bloc.dart';
import 'package:vitalflow/features/home/data/data_source/cart_remote_data_source.dart';
import 'package:vitalflow/features/home/data/data_source/home_data_source.dart';
import 'package:vitalflow/features/home/data/data_source/order_remote_data_source.dart';
import 'package:vitalflow/features/home/data/data_source/remote_data_source/home_remote_data_source.dart';
import 'package:vitalflow/features/home/data/repository/cart_repository.dart';
import 'package:vitalflow/features/home/data/repository/item_repository.dart';
import 'package:vitalflow/features/home/data/repository/order_repository.dart';
import 'package:vitalflow/features/home/domain/repository/item_repository.dart';
import 'package:vitalflow/features/home/domain/repository/order_repository.dart';
import 'package:vitalflow/features/home/domain/use_case/delete_cart_item_use_case.dart';
import 'package:vitalflow/features/home/domain/use_case/get_cart_use_case.dart';
import 'package:vitalflow/features/home/domain/use_case/get_items_usecase.dart';
import 'package:vitalflow/features/home/domain/use_case/get_order_usecase.dart';
import 'package:vitalflow/features/home/domain/use_case/save_cart_use_case.dart';
import 'package:vitalflow/features/home/domain/use_case/save_order_use_case.dart';
import 'package:vitalflow/features/home/presentation/view_model/bloc/dashboard_bloc.dart';
import 'package:vitalflow/features/home/presentation/view_model/bloc/orders_bloc.dart';
import 'package:vitalflow/features/home/presentation/view_model/home_bloc.dart';
import 'package:vitalflow/features/onboarding/presentation/view_model/on_bording_cubit.dart';
import 'package:vitalflow/features/splash/presentation/view_model/splash_cubit.dart';

final getIt = GetIt.instance;

Future<void> initDependencies() async {
  await _initHiveService();
  await _initDataSources();
  await _initSharedPreferences();
  await _initAuthDependencies();
  await _initSplashScreenDependencies();
  await _initOnBoardingScreenDependencies();
  await _initLoginScreenDependencies();
  await _initHomeDependencies();
  await _initDashboardDependencies();
  await _initOrdersDependencies(); // No duplicate _initCartDependencies
}

// _initHiveService() {
//   getIt.registerLazySingleton<HiveService>(() => HiveService());
// }

Future<void> _initHiveService() async {
  await HiveService.init(); // Initialize Hive
  getIt.registerSingleton<HiveService>(
      HiveService()); // Register singleton instance
}

Future<void> _initSharedPreferences() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
}

// Add HiveService to data sources
_initDataSources() {
  getIt.registerLazySingleton<Dio>(() => ApiService(Dio()).dio);
  // getIt.registerLazySingleton<HiveService>(() => HiveService());
  getIt.registerLazySingleton<IRemoteDataSource>(
      () => RemoteDataSource(getIt<Dio>(), getIt<HiveService>()));
  getIt.registerLazySingleton<ICartRemoteDataSource>(
      () => CartRemoteDataSource(getIt<Dio>(), getIt<HiveService>()));
  getIt.registerLazySingleton<IOrderRemoteDataSource>(
      () => OrderRemoteDataSource(getIt<Dio>(), getIt<HiveService>()));
}

_initAuthDependencies() {
  getIt.registerLazySingleton<AuthLocalDataSource>(
      () => AuthLocalDataSource(getIt<HiveService>()));
  getIt.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSource(getIt<Dio>()));
  getIt.registerLazySingleton<AuthLocalRepository>(
      () => AuthLocalRepository(getIt<AuthLocalDataSource>()));
  getIt.registerLazySingleton<AuthRemoteRepository>(
      () => AuthRemoteRepository(getIt<AuthRemoteDataSource>()));
  getIt.registerLazySingleton<SignupUsecase>(
      () => SignupUsecase(getIt<AuthRemoteRepository>()));
  getIt.registerLazySingleton<UploadImageUsecase>(
      () => UploadImageUsecase(getIt<AuthRemoteRepository>()));
  getIt.registerFactory<SignUpBloc>(() => SignUpBloc(
        signupUseCase: getIt<SignupUsecase>(),
        uploadImageUsecase: getIt<UploadImageUsecase>(),
      ));
}

_initSplashScreenDependencies() async {
  getIt
      .registerFactory<SplashCubit>(() => SplashCubit(getIt<OnBordingCubit>()));
}

_initHomeDependencies() async {
  getIt.registerLazySingleton<IItemRepository>(
      () => ItemRepository(getIt<IRemoteDataSource>()));
  getIt.registerLazySingleton<GetItemsUseCase>(
      () => GetItemsUseCase(getIt<IItemRepository>()));
  // Cart dependencies moved here
  // getIt.registerLazySingleton<ICartRemoteDataSource>(
  //     () => CartRemoteDataSource(getIt<Dio>(),getIt<HiveService>()));
  getIt.registerLazySingleton<ICartRepository>(
      () => CartRepository(getIt<ICartRemoteDataSource>()));
  getIt.registerLazySingleton<GetCartUseCase>(
      () => GetCartUseCase(getIt<ICartRepository>()));
  getIt.registerLazySingleton<SaveCartUseCase>(
      () => SaveCartUseCase(getIt<ICartRepository>()));
  getIt.registerLazySingleton<DeleteCartItemUseCase>(
      () => DeleteCartItemUseCase(getIt<ICartRepository>()));
  getIt.registerFactory<HomeBloc>(() => HomeBloc(
        getIt<GetItemsUseCase>(),
        getIt<GetCartUseCase>(),
        getIt<SaveCartUseCase>(),
        getIt<DeleteCartItemUseCase>(),
      ));
}

_initOnBoardingScreenDependencies() async {
  getIt.registerFactory<OnBordingCubit>(
      () => OnBordingCubit(getIt<LoginBloc>()));
}

_initLoginScreenDependencies() async {
  getIt.registerLazySingleton<TokenSharedPrefs>(
      () => TokenSharedPrefs(getIt<SharedPreferences>()));
  getIt.registerLazySingleton<LoginUseCase>(() =>
      LoginUseCase(getIt<AuthRemoteRepository>(), getIt<TokenSharedPrefs>()));
  getIt.registerFactory<LoginBloc>(() => LoginBloc(
        signUpBloc: getIt<SignUpBloc>(),
        homeCubit: getIt<HomeBloc>(),
        loginUseCase: getIt<LoginUseCase>(),
      ));
}

_initDashboardDependencies() async {
  if (!getIt.isRegistered<GetItemsUseCase>()) {
    getIt.registerLazySingleton<GetItemsUseCase>(
        () => GetItemsUseCase(getIt<IItemRepository>()));
  }
  getIt.registerFactory<DashboardBloc>(
      () => DashboardBloc(getIt<GetItemsUseCase>()));
}

_initOrdersDependencies() async {
  // getIt.registerLazySingleton<IOrderRemoteDataSource>(
  //     () => OrderRemoteDataSource(getIt<Dio>(),getIt<HiveService>()));
  getIt.registerLazySingleton<IOrderRepository>(
      () => OrderRepository(getIt<IOrderRemoteDataSource>()));
  getIt.registerLazySingleton<GetOrdersUseCase>(
      () => GetOrdersUseCase(getIt<IOrderRepository>()));
  getIt.registerLazySingleton<SaveOrderUseCase>(
      () => SaveOrderUseCase(getIt<IOrderRepository>()));
  getIt.registerFactory<OrdersBloc>(
      () => OrdersBloc(getIt<GetOrdersUseCase>(), getIt<SaveOrderUseCase>()));
}
