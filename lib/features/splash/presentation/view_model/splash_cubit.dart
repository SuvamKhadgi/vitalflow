import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vitalflow/features/onboarding/presentation/view/on_boarding_screen.dart';
import 'package:vitalflow/features/onboarding/presentation/view_model/on_bording_cubit.dart';

class SplashCubit extends Cubit<void> {
  final OnBordingCubit _onBordingCubit;
  SplashCubit(this._onBordingCubit) : super(null);

  Future<void> init(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 2), () async {
      // Open Login page or Onboarding Screen

      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => BlocProvider.value(
              value: _onBordingCubit,
              // value: _loginBloc,
              child: const OnboardingScreen(),
            ),
          ),
        );
      }
    });
  }
}
