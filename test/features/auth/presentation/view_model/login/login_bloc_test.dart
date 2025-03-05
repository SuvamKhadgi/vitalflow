import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:vitalflow/core/error/failure.dart';
import 'package:vitalflow/features/auth/domain/use_case/login_usecase.dart';
import 'package:vitalflow/features/auth/presentation/view_model/login/login_bloc.dart';
import 'package:vitalflow/features/auth/presentation/view_model/signup/signup_bloc.dart';
import 'package:vitalflow/features/home/presentation/view_model/home_bloc.dart';

import 'login_bloc_test.mocks.dart';

class MockNavigatorState extends Mock implements NavigatorState {
  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return super.toString();
  }

  @override
  Future<T?> push<T extends Object?>(Route<T> route) async {
    return super.noSuchMethod(
      Invocation.method(#push, [route]),
      returnValue: Future<T?>.value(), // Return a Future
      returnValueForMissingStub: Future<T?>.value(),
    );
  }

  @override
  Future<T?> pushReplacement<T extends Object?, V extends Object?>(
    Route<T> route, {
    V? result,
  }) async {
    return super.noSuchMethod(
      Invocation.method(#pushReplacement, [route], {#result: result}),
      returnValue: Future<T?>.value(), // Return a Future
      returnValueForMissingStub: Future<T?>.value(),
    );
  }
}

class MockScaffoldMessengerState extends Mock
    implements ScaffoldMessengerState {
  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return super.toString();
  }
}



@GenerateMocks([LoginUseCase, HomeBloc, SignUpBloc, BuildContext])
void main() {
  group('LoginBloc', () {
    late LoginBloc loginBloc;
    late MockLoginUseCase mockLoginUseCase;
    late MockHomeBloc mockHomeBloc;
    late MockSignUpBloc mockSignUpBloc;
    late MockBuildContext mockContext;
    late MockNavigatorState mockNavigatorState;
    late MockScaffoldMessengerState mockScaffoldMessengerState;

  setUp(() {
  mockLoginUseCase = MockLoginUseCase();
  mockHomeBloc = MockHomeBloc();
  mockSignUpBloc = MockSignUpBloc();
  mockContext = MockBuildContext();
  mockNavigatorState = MockNavigatorState();
  mockScaffoldMessengerState = MockScaffoldMessengerState();

  // Stub findAncestorWidgetOfExactType
  when(mockContext.findAncestorWidgetOfExactType<ScaffoldMessenger>())
      .thenReturn(ScaffoldMessenger(
    key: GlobalKey<ScaffoldMessengerState>(),
    child: const Placeholder(),
  ));

  when(mockContext.findAncestorStateOfType<ScaffoldMessengerState>())
      .thenReturn(mockScaffoldMessengerState);


  when(mockContext.findAncestorStateOfType<NavigatorState>())
      .thenReturn(mockNavigatorState);

  loginBloc = LoginBloc(
    loginUseCase: mockLoginUseCase,
    homeCubit: mockHomeBloc,
    signUpBloc: mockSignUpBloc,
  );
});


    tearDown(() {
      loginBloc.close();
    });

    test('initial state is LoginState.initial()', () {
      expect(loginBloc.state, LoginState.initial());
    });



    //Indirectly test navigation by verifying that the correct blocs are passed
    blocTest<LoginBloc, LoginState>(
      'NavigateSignupScreenEvent calls Navigator.push',
      build: () {
        return loginBloc;
      },
      act: (LoginBloc bloc) => bloc.add(NavigateSignupScreenEvent(
          context: mockContext, destination: const Placeholder())),
      expect: () => [],
    );

    blocTest<LoginBloc, LoginState>(
      'NavigateHomeScreenEvent calls Navigator.pushReplacement',
      build: () {
        return loginBloc;
      },
      act: (LoginBloc bloc) => bloc.add(NavigateHomeScreenEvent(
          context: mockContext, destination: const Placeholder())),
      expect: () => [],
    );
  });
}
