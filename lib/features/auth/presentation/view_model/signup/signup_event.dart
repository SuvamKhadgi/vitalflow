part of 'signup_bloc.dart';

// import 'package:equatable/equatable.dart';

sealed class SignupEvent extends Equatable {
  const SignupEvent();

  @override
  List<Object> get props => [];
}

class NavigateloginScreenEvent extends SignupEvent {
  final BuildContext context;
  final Widget destination;

  const NavigateloginScreenEvent({
    required this.context,
    required this.destination,
  });
}

class NavigateHomeScreenEvent extends SignupEvent {
  final BuildContext context;
  final Widget destination;

  const NavigateHomeScreenEvent({
    required this.context,
    required this.destination,
  });
}

class SignupUser extends SignupEvent {
  final BuildContext context;
  final String email;
  final String password;
  final String name;

  const SignupUser({
    required this.context,
    required this.email,
    required this.password,
    required this.name,
  });
}
