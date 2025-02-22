import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vitalflow/core/common/snackbar/my_snackbar.dart';
import 'package:vitalflow/features/auth/domain/use_case/signup_usecase.dart';
import 'package:vitalflow/features/auth/domain/use_case/upload_image_usecase.dart';

part 'signup_event.dart';
part 'signup_state.dart';

class SignUpBloc extends Bloc<SignupEvent, SignupState> {
  final SignupUsecase _signupUsecase;
  final UploadImageUsecase _uploadImageUsecase;

  SignUpBloc({
    required SignupUsecase signupUseCase,
    required UploadImageUsecase uploadImageUsecase,
    // required LoginUseCase loginUseCase
    // required LoginBloc loginBloc
  })  : _signupUsecase = signupUseCase,
        _uploadImageUsecase = uploadImageUsecase,
        // _loginUseCase = loginUseCase,
        // _loginBloc = loginBloc,
        super(const SignupState.initial()) {
    on<SignupUser>(_onSignupEvent);
    on<LoadImage>(_onLoadImage);
  }

  void _onSignupEvent(
    SignupUser event,
    Emitter<SignupState> emit,
  ) async {
    debugPrint("📢 Signing up with image: ${state.imageName}");

    emit(state.copyWith(isLoading: true));
    final result = await _signupUsecase.call(SignupUserParams(
      name: event.name,
      image: state.imageName,
      email: event.email,
      password: event.password,
    ));

    result.fold(
      (l) => emit(state.copyWith(isLoading: false, isSuccess: false)),
      (r) {
        emit(state.copyWith(isLoading: false, isSuccess: true));
        showMySnackBar(
            context: event.context, message: "Registration Successful");
      },
    );
  }

  void _onLoadImage(
    LoadImage event,
    Emitter<SignupState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    final result =
        await _uploadImageUsecase.call(UploadImageParams(file: event.file));
    result.fold(
      (l) => emit(state.copyWith(isLoading: false, isSuccess: false)),
      (r) {
        emit(state.copyWith(isLoading: false, isSuccess: true, imageName: r));
      },
    );
  }
}
