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
import 'package:vitalflow/features/home/presentation/view_model/home_cubit.dart';
import 'package:vitalflow/features/onboarding/presentation/view_model/on_bording_cubit.dart';
import 'package:vitalflow/features/splash/presentation/view_model/splash_cubit.dart';

final getIt = GetIt.instance;

Future<void> initDependencies() async {
  await _initHiveService();
  await _initSplashScreenDependencies();
  await _initOnBoardingScreenDependencies();
  await _initLoginScreenDependencies();
  await _initHomeDependencies();
  await _initSharedPreferences();
  await _initRegisterDependencies();
  await _initApiService();
}

_initHiveService() {
  getIt.registerLazySingleton<HiveService>(() => HiveService());
}

Future<void> _initSharedPreferences() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
}

_initApiService() {
  // Remote Data Source
  getIt.registerLazySingleton<Dio>(
    () => ApiService(Dio()).dio,
  );
}

_initRegisterDependencies() {
  // ==========data source================
  getIt.registerLazySingleton(
    () => AuthLocalDataSource(getIt<HiveService>()),
  );
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSource(getIt<Dio>()),
  );

// ==========repository================

  getIt.registerLazySingleton(
    () => AuthLocalRepository(getIt<AuthLocalDataSource>()),
  );
  getIt.registerLazySingleton<AuthRemoteRepository>(
    () => AuthRemoteRepository(getIt<AuthRemoteDataSource>()),
  );

// ==========usecase================
  getIt.registerLazySingleton<SignupUsecase>(
    () => SignupUsecase(
      // getIt<AuthLocalRepository>(),
      getIt<AuthRemoteRepository>(),
    ),
  );

  getIt.registerLazySingleton<UploadImageUsecase>(
    () => UploadImageUsecase(
      getIt<AuthRemoteRepository>(),
    ),
  );

  getIt.registerFactory<SignUpBloc>(() => SignUpBloc(
        // batchBloc: getIt<BatchBloc>(),
        // courseBloc: getIt<CourseBloc>(),
        signupUseCase: getIt(),
        uploadImageUsecase: getIt(),
        // loginBloc: getIt<LoginBloc>()
      ));
}

_initSplashScreenDependencies() async {
  getIt.registerFactory<SplashCubit>(
    () => SplashCubit(getIt<OnBordingCubit>()),
    // () => SplashCubit(getIt<LoginBloc>()),
  );
}

_initHomeDependencies() async {
  getIt.registerFactory<HomeCubit>(
    () => HomeCubit(),
  );
}

_initOnBoardingScreenDependencies() async {
  getIt.registerFactory<OnBordingCubit>(
      () => OnBordingCubit(getIt<LoginBloc>()));
}

_initLoginScreenDependencies() async {
// =============tokrnSharedPrefs================
  getIt.registerLazySingleton<TokenSharedPrefs>(
    () => TokenSharedPrefs(getIt<SharedPreferences>()),
  );

  // ===============useCase================
  getIt.registerLazySingleton<LoginUseCase>(() => LoginUseCase(
        getIt<AuthRemoteRepository>(),
        getIt<TokenSharedPrefs>(),
      ));

  getIt.registerFactory<LoginBloc>(
    () => LoginBloc(
      signUpBloc: getIt<SignUpBloc>(),
      homeCubit: getIt<HomeCubit>(),
      loginUseCase: getIt<LoginUseCase>(),
    ),
  );
}
