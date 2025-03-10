import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vitalflow/app/di/di.dart';
import 'package:vitalflow/core/common/snackbar/my_snackbar.dart';
import 'package:vitalflow/features/auth/domain/use_case/login_usecase.dart';
import 'package:vitalflow/features/auth/presentation/view_model/signup/signup_bloc.dart';
import 'package:vitalflow/features/home/presentation/view/home_view.dart';
import 'package:vitalflow/features/home/presentation/view_model/home_bloc.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final SignUpBloc _signUpBloc;
  final HomeBloc _homeCubit;
  final LoginUseCase _loginUseCase;

  LoginBloc({
    required LoginUseCase loginUseCase,
    required HomeBloc homeCubit,
    required SignUpBloc signUpBloc,
  })  : _signUpBloc = signUpBloc,
        _homeCubit = homeCubit,
        _loginUseCase = loginUseCase,
        super(LoginState.initial()) {
    on<NavigateSignupScreenEvent>((event, emit) {
      Navigator.push(
        event.context,
        MaterialPageRoute(
          builder: (context) => MultiBlocProvider(
            providers: [BlocProvider.value(value: _signUpBloc)],
            child: event.destination,
          ),
        ),
      );
    });

    on<NavigateHomeScreenEvent>((event, emit) {
      Navigator.pushReplacement(
        event.context,
        MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => getIt<HomeBloc>(),
            child: event.destination,
          ),
        ),
      );
    });

    on<LoginUserEvent>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      final result = await _loginUseCase(LoginParams(
        email: event.email,
        password: event.password,
      ));

      result.fold(
        (failure) {
          emit(state.copyWith(isLoading: false, isSuccess: false));
          showMySnackBar(
            context: event.context,
            message: "Invalid Credentials",
            color: Colors.red,
          );
        },
        (token) {
          emit(state.copyWith(isLoading: false, isSuccess: true));
          showMySnackBar(
            context: event.context,
            message: "Login Successful",
            color: Colors.green,
          );
          add(NavigateHomeScreenEvent(
            context: event.context,
            destination: const HomeView(),
          ));
        },
      );
    });
  }
}