// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:vitalflow/features/splash/presentation/view_model/splash_cubit.dart';
// // import 'package:mobapp/screen/on_boarding_screen.dart';

// class SplashScreenView extends StatefulWidget {
//   const SplashScreenView({super.key});

//   @override
//   State<SplashScreenView> createState() => _SplashScreenViewState();
// }

// class _SplashScreenViewState extends State<SplashScreenView> {
//   @override
//   void initState() {
//     super.initState();
//     context.read<SplashCubit>().init(context);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Center(child: Image.asset('assets/images/logos.png')),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vitalflow/app/di/di.dart';
import 'package:vitalflow/features/auth/presentation/view_model/login/login_bloc.dart';
import 'package:vitalflow/features/auth/presentation/view_model/signup/signup_bloc.dart';
import 'package:vitalflow/features/home/presentation/view/home_view.dart';
import 'package:vitalflow/features/home/presentation/view_model/home_bloc.dart';
import 'package:vitalflow/features/onboarding/presentation/view/on_boarding_screen.dart';
import 'package:vitalflow/features/onboarding/presentation/view_model/on_bording_cubit.dart';
import 'package:vitalflow/features/splash/presentation/view_model/splash_cubit.dart';

class SplashScreenView extends StatelessWidget {
  const SplashScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<SplashCubit, bool>(
        listener: (context, state) {
          print('SplashScreenView: State changed to $state');
          if (state) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => MultiBlocProvider(
                  providers: [
                    BlocProvider.value(value: getIt<LoginBloc>()),
                    BlocProvider.value(value: getIt<SignUpBloc>()),
                    BlocProvider.value(value: getIt<HomeBloc>()),
                    BlocProvider.value(value: getIt<OnBordingCubit>()), // Add OnBordingCubit
                  ],
                  child: const OnboardingScreen(),
                ),
              ),
            );
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => BlocProvider.value(
                  value: getIt<HomeBloc>(),
                  child: const HomeView(),
                ),
              ),
            );
          }
        },
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/logos.png', height: 100),
              const SizedBox(height: 20),
              const CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}