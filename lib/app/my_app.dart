import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vitalflow/app/di/di.dart';
import 'package:vitalflow/core/app_theme/app_theme.dart';
import 'package:vitalflow/features/splash/presentation/view/splash_screen_view.dart';
import 'package:vitalflow/features/splash/presentation/view_model/splash_cubit.dart';

class ThemeCubit extends Cubit<bool> {
  ThemeCubit() : super(false); // false = light mode

  void toggleTheme() => emit(!state);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ThemeCubit(),
      child: BlocBuilder<ThemeCubit, bool>(
        builder: (context, isDarkMode) {
          return MaterialApp(
              theme: getLightTheme(),
              darkTheme: getDarkTheme(),
              themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
              debugShowCheckedModeBanner: false,
              home: BlocProvider.value(
                value: getIt<SplashCubit>(),
                child: const SplashScreenView(),
              ));
        },
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:vitalflow/app/di/di.dart';
// import 'package:vitalflow/core/app_theme/app_theme.dart';
// import 'package:vitalflow/features/splash/presentation/view/splash_screen_view.dart';
// import 'package:vitalflow/features/splash/presentation/view_model/splash_cubit.dart';

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//         debugShowCheckedModeBanner: false,
//         theme: getApplicationTheme(),
//         home: BlocProvider.value(
//           value: getIt<SplashCubit>(),
//           child: const SplashScreenView(),
//         ));
//   }
// }
