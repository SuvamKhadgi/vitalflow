

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:introduction_screen/introduction_screen.dart';
// import 'package:vitalflow/features/onboarding/presentation/view_model/on_bording_cubit.dart';

// class OnboardingScreen extends StatefulWidget {
//   const OnboardingScreen({super.key});

//   @override
//   State<OnboardingScreen> createState() => _OnboardingScreenState();
// }

// class _OnboardingScreenState extends State<OnboardingScreen> {
//   late final OnBordingCubit _onBordingCubit;

//   @override
//   void initState() {
//     super.initState();
//     // context.read<SplashCubit>().init(context);
//     _onBordingCubit = context.read<OnBordingCubit>();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: IntroductionScreen(
//         pages: _onBordingCubit.getPages(context), // Fetch pages from ViewModel
//         onDone: () => _onBordingCubit.navigateToLogin(context),
//         onSkip: () => _onBordingCubit.navigateToLogin(context),
//         showSkipButton: true,
//         skip: const Text("Skip"),
//         next: const Icon(Icons.arrow_forward),
//         done: const Text("Get Started",
//             style: TextStyle(fontWeight: FontWeight.bold)),
//         dotsDecorator: _onBordingCubit.getDotsDecorator(),
//       ),
//     );
//   }
// }

// // var viewModel = OnBordingCubit();


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:vitalflow/features/onboarding/presentation/view_model/on_bording_cubit.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late final OnBordingCubit _onBordingCubit;

  @override
  void initState() {
    super.initState();
    _onBordingCubit = context.read<OnBordingCubit>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IntroductionScreen(
        pages: _onBordingCubit.getPages(context),
        onDone: () => _onBordingCubit.navigateToLogin(context),
        onSkip: () => _onBordingCubit.navigateToLogin(context),
        showSkipButton: true,
        skip: const Text("Skip"),
        next: const Icon(Icons.arrow_forward),
        done: const Text("Get Started", style: TextStyle(fontWeight: FontWeight.bold)),
        dotsDecorator: _onBordingCubit.getDotsDecorator(),
      ),
    );
  }
}