// import 'dart:io';
// import 'package:equatable/equatable.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:vitalflow/app/di/di.dart';
// import 'package:vitalflow/core/common/snackbar/my_snackbar.dart';
// import 'package:vitalflow/features/auth/domain/use_case/signup_usecase.dart';
// import 'package:vitalflow/features/auth/domain/use_case/upload_image_usecase.dart';
// import 'package:vitalflow/features/auth/presentation/view/login_screen.dart';
// import 'package:vitalflow/features/auth/presentation/view_model/login/login_bloc.dart';
// import 'package:vitalflow/features/home/presentation/view_model/home_bloc.dart';

// part 'signup_event.dart';
// part 'signup_state.dart';

// class SignUpBloc extends Bloc<SignupEvent, SignupState> {
//   final SignupUsecase _signupUsecase;
//   final UploadImageUsecase _uploadImageUsecase;

//   SignUpBloc({
//     required SignupUsecase signupUseCase,
//     required UploadImageUsecase uploadImageUsecase,
//   })  : _signupUsecase = signupUseCase,
//         _uploadImageUsecase = uploadImageUsecase,
//         super(const SignupState.initial()) {
//     on<SignupUser>(_onSignupEvent);
//     on<LoadImage>(_onLoadImage);
//     on<NavigateloginScreenEvent>(_onNavigateLoginScreen);
//   }

//   void _onSignupEvent(SignupUser event, Emitter<SignupState> emit) async {
//     debugPrint("📢 Signing up with image: ${state.imageName}");
//     emit(state.copyWith(isLoading: true));
//     final result = await _signupUsecase.call(SignupUserParams(
//       name: event.name,
//       image: state.imageName,
//       email: event.email,
//       password: event.password,
//     ));

//     result.fold(
//       (l) {
//         emit(state.copyWith(isLoading: false, isSuccess: false));
//         showMySnackBar(context: event.context, message: "Signup Failed: ${l.message}", color: Colors.red);
//       },
//       (r) {
//         emit(state.copyWith(isLoading: false, isSuccess: true));
//         showMySnackBar(context: event.context, message: "Registration Successful", color: Colors.green);
//         add(NavigateloginScreenEvent(context: event.context, destination: LoginScreen()));
//       },
//     );
//   }

//   void _onLoadImage(LoadImage event, Emitter<SignupState> emit) async {
//     emit(state.copyWith(isLoading: true));
//     final result = await _uploadImageUsecase.call(UploadImageParams(file: event.file));
//     result.fold(
//       (l) => emit(state.copyWith(isLoading: false, isSuccess: false)),
//       (r) {
//         emit(state.copyWith(isLoading: false, isSuccess: true, imageName: r));
//       },
//     );
//   }

//   void _onNavigateLoginScreen(NavigateloginScreenEvent event, Emitter<SignupState> emit) {
//     Navigator.push(
//       event.context,
//       MaterialPageRoute(
//         builder: (context) => MultiBlocProvider(
//           providers: [
//             BlocProvider.value(value: getIt<LoginBloc>()),
//             BlocProvider.value(value: getIt<SignUpBloc>()),
//             BlocProvider.value(value: getIt<HomeBloc>()),
//           ],
//           child: event.destination,
//         ),
//       ),
//     );
//   }
// }


import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vitalflow/app/di/di.dart';
import 'package:vitalflow/core/common/snackbar/my_snackbar.dart';
import 'package:vitalflow/features/auth/domain/use_case/signup_usecase.dart';
import 'package:vitalflow/features/auth/domain/use_case/upload_image_usecase.dart';
import 'package:vitalflow/features/auth/presentation/view/login_screen.dart';
import 'package:vitalflow/features/auth/presentation/view_model/login/login_bloc.dart';
import 'package:vitalflow/features/home/presentation/view_model/home_bloc.dart';

part 'signup_event.dart';
part 'signup_state.dart';

class SignUpBloc extends Bloc<SignupEvent, SignupState> {
  final SignupUsecase _signupUsecase;
  final UploadImageUsecase _uploadImageUsecase;

  SignUpBloc({
    required SignupUsecase signupUseCase,
    required UploadImageUsecase uploadImageUsecase,
  })  : _signupUsecase = signupUseCase,
        _uploadImageUsecase = uploadImageUsecase,
        super(const SignupState.initial()) {
    on<SignupUser>(_onSignupEvent);
    on<LoadImage>(_onLoadImage);
    on<NavigateloginScreenEvent>(_onNavigateLoginScreen);
  }

  void _onSignupEvent(SignupUser event, Emitter<SignupState> emit) async {
    debugPrint("📢 Signing up with image: ${state.imageName}");
    emit(state.copyWith(isLoading: true));
    final result = await _signupUsecase.call(SignupUserParams(
      name: event.name,
      image: state.imageName,
      email: event.email,
      password: event.password,
    ));

    result.fold(
      (l) {
        emit(state.copyWith(isLoading: false, isSuccess: false));
        showMySnackBar(context: event.context, message: l.message, color: Colors.red);
      },
      (r) {
        emit(state.copyWith(isLoading: false, isSuccess: true));
        showMySnackBar(context: event.context, message: "Registration Successful", color: Colors.green);
        add(NavigateloginScreenEvent(context: event.context, destination: LoginScreen()));
      },
    );
  }

  void _onLoadImage(LoadImage event, Emitter<SignupState> emit) async {
    emit(state.copyWith(isLoading: true));
    final result = await _uploadImageUsecase.call(UploadImageParams(file: event.file));
    result.fold(
      (l) => emit(state.copyWith(isLoading: false, isSuccess: false)),
      (r) {
        emit(state.copyWith(isLoading: false, isSuccess: true, imageName: r));
      },
    );
  }

  void _onNavigateLoginScreen(NavigateloginScreenEvent event, Emitter<SignupState> emit) {
    Navigator.push(
      event.context,
      MaterialPageRoute(
        builder: (context) => MultiBlocProvider(
          providers: [
            BlocProvider.value(value: getIt<LoginBloc>()),
            BlocProvider.value(value: getIt<SignUpBloc>()),
            BlocProvider.value(value: getIt<HomeBloc>()),
          ],
          child: event.destination,
        ),
      ),
    );
  }
}