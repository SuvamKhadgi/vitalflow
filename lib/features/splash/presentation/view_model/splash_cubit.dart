// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:vitalflow/features/onboarding/presentation/view/on_boarding_screen.dart';
// import 'package:vitalflow/features/onboarding/presentation/view_model/on_bording_cubit.dart';

// class SplashCubit extends Cubit<void> {
//   final OnBordingCubit _onBordingCubit;
//   SplashCubit(this._onBordingCubit) : super(null);

//   Future<void> init(BuildContext context) async {
//     await Future.delayed(const Duration(seconds: 2), () async {
//       // Open Login page or Onboarding Screen

//       if (context.mounted) {
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(
//             builder: (context) => BlocProvider.value(
//               value: _onBordingCubit,
//               // value: _loginBloc,
//               child: const OnboardingScreen(),
//             ),
//           ),
//         );
//       }
//     });
//   }
// }
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vitalflow/app/di/di.dart';
import 'package:vitalflow/app/shared_prefs/token_shared_prefs.dart';
import 'package:vitalflow/features/onboarding/presentation/view_model/on_bording_cubit.dart';

class SplashCubit extends Cubit<bool> {
  final OnBordingCubit onBordingCubit;

  SplashCubit(this.onBordingCubit) : super(false) {
    _checkNavigation();
  }

  Future<void> _checkNavigation() async {
    await Future.delayed(const Duration(seconds: 2)); // Splash delay
    final tokenResult = await getIt<TokenSharedPrefs>().getToken();
    tokenResult.fold(
      (failure) {
        print('SplashCubit: Token retrieval failed: ${failure.message}');
        onBordingCubit.navigateToOnboarding();
        emit(true);
      },
      (token) {
        print('SplashCubit: Retrieved token: "$token"');
        // Handle "null" string explicitly
        if (token == null || token.isEmpty || token == "null") {
          print('SplashCubit: No valid token, navigating to OnboardingScreen');
          onBordingCubit.navigateToOnboarding();
          emit(true);
        } else {
          try {
            if (token.split('.').length == 3) {
              print('SplashCubit: Valid token, navigating to HomeView');
              onBordingCubit.navigateToHome();
              emit(false);
            } else {
              print('SplashCubit: Invalid token format, navigating to OnboardingScreen');
              onBordingCubit.navigateToOnboarding();
              emit(true);
            }
          } catch (e) {
            print('SplashCubit: Token parsing error: $e, navigating to OnboardingScreen');
            onBordingCubit.navigateToOnboarding();
            emit(true);
          }
        }
      },
    );
  }
}