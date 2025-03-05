// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:introduction_screen/introduction_screen.dart';
// import 'package:vitalflow/features/auth/presentation/view/login_screen.dart';
// import 'package:vitalflow/features/auth/presentation/view_model/login/login_bloc.dart';

// class OnBordingCubit extends Cubit<void> {
//   // OnBordingCubit() : super(0);
//   OnBordingCubit(this._loginBloc) : super(null);
//   final LoginBloc _loginBloc;

//   List<PageViewModel> getPages(BuildContext context) {
//     return [
//       PageViewModel(
//         title: "Your Health, Just a Tap Away!",
//         body:
//             "Discover a seamless way to get the medicines you need, delivered to your doorstep.",
//         image: Center(
//           child: Image.asset('assets/images/health1.png', height: 200),
//         ),
//         decoration: getPageDecoration(),
//       ),
//       PageViewModel(
//         title: "Order Medicines Easily",
//         body:
//             "Browse thousands of medications and health products, all at your fingertips.",
//         image: Center(
//           child: Image.asset('assets/images/order1.png', height: 200),
//         ),
//         decoration: getPageDecoration(),
//       ),
//       PageViewModel(
//         title: "Fast Delivery & Reliable Support",
//         body:
//             "Enjoy fast deliveries, live tracking, and personalized support whenever you need it.",
//         image: Center(
//           child: Image.asset('assets/images/order.png', height: 200),
//         ),
//         decoration: getPageDecoration(),
//       ),
//     ];
//   }

//   // Page decoration for all pages
//   PageDecoration getPageDecoration() {
//     return const PageDecoration(
//       titleTextStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//       bodyTextStyle: TextStyle(fontSize: 16),
//       bodyPadding: EdgeInsets.all(16.0),
//       imagePadding: EdgeInsets.only(top: 40),
//       pageColor: Color.fromARGB(255, 144, 202, 249),
//     );
//   }

//   // Dots decorator for pagination
//   DotsDecorator getDotsDecorator() {
//     return DotsDecorator(
//       size: const Size(10, 10),
//       color: Colors.grey,
//       activeSize: const Size(22, 10),
//       activeShape:
//           RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
//       activeColor: Colors.blue,
//     );
//   }

//   // Navigation to Login Screen
//   void navigateToLogin(BuildContext context) {
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(
//           builder: (context) => BlocProvider.value(
//                 value: _loginBloc,
//                 child: LoginScreen(),
//               )),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:vitalflow/app/di/di.dart';
import 'package:vitalflow/features/auth/presentation/view/login_screen.dart';
import 'package:vitalflow/features/auth/presentation/view_model/login/login_bloc.dart';
import 'package:vitalflow/features/auth/presentation/view_model/signup/signup_bloc.dart';
import 'package:vitalflow/features/home/presentation/view/home_view.dart';
import 'package:vitalflow/features/home/presentation/view_model/home_bloc.dart';

class OnBordingCubit extends Cubit<bool> {
  final LoginBloc _loginBloc;

  OnBordingCubit(this._loginBloc) : super(false);

  List<PageViewModel> getPages(BuildContext context) {
    return [
      PageViewModel(
        title: "Your Health, Just a Tap Away!",
        body: "Discover a seamless way to get the medicines you need, delivered to your doorstep.",
        image: Center(child: Image.asset('assets/images/health1.png', height: 200)),
        decoration: getPageDecoration(),
      ),
      PageViewModel(
        title: "Order Medicines Easily",
        body: "Browse thousands of medications and health products, all at your fingertips.",
        image: Center(child: Image.asset('assets/images/order1.png', height: 200)),
        decoration: getPageDecoration(),
      ),
      PageViewModel(
        title: "Fast Delivery & Reliable Support",
        body: "Enjoy fast deliveries, live tracking, and personalized support whenever you need it.",
        image: Center(child: Image.asset('assets/images/order.png', height: 200)),
        decoration: getPageDecoration(),
      ),
    ];
  }

  PageDecoration getPageDecoration() {
    return const PageDecoration(
      titleTextStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      bodyTextStyle: TextStyle(fontSize: 16),
      bodyPadding: EdgeInsets.all(16.0),
      imagePadding: EdgeInsets.only(top: 40),
      pageColor: Color.fromARGB(255, 144, 202, 249),
    );
  }

  DotsDecorator getDotsDecorator() {
    return DotsDecorator(
      size: const Size(10, 10),
      color: Colors.grey,
      activeSize: const Size(22, 10),
      activeShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      activeColor: Colors.blue,
    );
  }

  void navigateToOnboarding() {
    emit(true); // Signal SplashScreenView to go to OnboardingScreen
  }

  void navigateToLogin(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => MultiBlocProvider(
          providers: [
            BlocProvider.value(value: getIt<LoginBloc>()),
            BlocProvider.value(value: getIt<SignUpBloc>()),
            BlocProvider.value(value: getIt<HomeBloc>()),
          ],
          child: LoginScreen(),
        ),
      ),
    );
  }

  void navigateToHome() {
    emit(false); // Signal SplashScreenView to go to HomeView
  }
}