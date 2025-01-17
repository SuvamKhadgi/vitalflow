import 'package:get_it/get_it.dart';
import 'package:vitalflow/core/network/hive_service.dart';
import 'package:vitalflow/features/auth/data/data_source/local_datasource.dart/auth_local_datasource.dart';
import 'package:vitalflow/features/auth/data/repository/auth_local_repository/auth_local_repository.dart';
import 'package:vitalflow/features/auth/domain/use_case/login_usecase.dart';
import 'package:vitalflow/features/auth/domain/use_case/signup_usecase.dart';
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

  await _initRegisterDependencies();
}

_initHiveService() {
  getIt.registerLazySingleton<HiveService>(() => HiveService());
}

_initRegisterDependencies() {
  // init local data source
  getIt.registerLazySingleton(
    () => AuthLocalDataSource(getIt<HiveService>()),
  );
  // init local repository
  getIt.registerLazySingleton(
    () => AuthLocalRepository(getIt<AuthLocalDataSource>()),
  );

  // register use usecase
  getIt.registerLazySingleton<SignupUsecase>(
    () => SignupUsecase(
      getIt<AuthLocalRepository>(),
    ),
  );

  getIt.registerFactory<SignUpBloc>(() => SignUpBloc(
        // batchBloc: getIt<BatchBloc>(),
        // courseBloc: getIt<CourseBloc>(),
        signupUseCase: getIt(),
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
  getIt.registerLazySingleton(() => LoginUseCase(
        getIt<AuthLocalRepository>(),
      ));

  getIt.registerFactory<LoginBloc>(
    () => LoginBloc(
      signUpBloc: getIt<SignUpBloc>(),
      homeCubit: getIt<HomeCubit>(),
      loginUseCase: getIt<LoginUseCase>(),
    ),
  );
}
