import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vitalflow/app/di/di.dart';
import 'package:vitalflow/core/app_theme/app_theme.dart';
import 'package:vitalflow/features/splash/presentation/view/splash_screen_view.dart';
import 'package:vitalflow/features/splash/presentation/view_model/splash_cubit.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: getApplicationTheme(),
        home: BlocProvider.value(
          value: getIt<SplashCubit>(),
          child: const SplashScreenView(),
        ));
  }
}
