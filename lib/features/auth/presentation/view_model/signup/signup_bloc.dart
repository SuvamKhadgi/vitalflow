import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vitalflow/core/common/snackbar/my_snackbar.dart';
import 'package:vitalflow/features/auth/domain/use_case/signup_usecase.dart';

part 'signup_event.dart';
part 'signup_state.dart';

class SignUpBloc extends Bloc<SignupEvent, SignupState> {
  final SignupUsecase _signupUsecase;
  // final LoginUseCase _loginUseCase;
  // final LoginBloc _loginBloc;

  SignUpBloc({
    required SignupUsecase signupUseCase,
    // required LoginUseCase loginUseCase
    // required LoginBloc loginBloc
  })  : _signupUsecase = signupUseCase,
        // _loginUseCase = loginUseCase,
        // _loginBloc = loginBloc,
        super(SignupState.initial()) {
    on<SignupUser>(_onSignupEvent);
  }

  void _onSignupEvent(
    SignupUser event,
    Emitter<SignupState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    final result = await _signupUsecase.call(SignupUserParams(
      name: event.name,
      // lname: event.lName,
      // phone: event.phone,
      // batch: event.batch,
      // courses: _courseBloc.state.courses,
      email: event.email,
      password: event.password,
    ));
    // on<NavigateloginScreenEvent>(
    //   (event, emit) {
    //     Navigator.pushReplacement(
    //       event.context,
    //       MaterialPageRoute(
    //         builder: (context) => MultiBlocProvider(
    //           providers: [BlocProvider.value(value: _loginBloc)],
    //           child: event.destination,
    //         ),
    //       ),
    //     );
    //   },
    // );

    result.fold(
      (l) => emit(state.copyWith(isLoading: false, isSuccess: false)),
      (r) {
        emit(state.copyWith(isLoading: false, isSuccess: true));
        showMySnackBar(
            context: event.context, message: "Registration Successful");
      },
    );
  }
}
