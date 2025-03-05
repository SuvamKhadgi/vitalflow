import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:vitalflow/features/auth/presentation/view/login_screen.dart';
import 'package:vitalflow/features/auth/presentation/view/sign_up.dart';
import 'package:vitalflow/features/auth/presentation/view_model/login/login_bloc.dart';
import 'package:vitalflow/features/auth/presentation/view_model/signup/signup_bloc.dart';
import 'package:vitalflow/features/home/presentation/view_model/home_bloc.dart';
import 'package:vitalflow/features/home/presentation/view_model/home_state.dart'; // Real HomeState

// Mock classes
@GenerateMocks([LoginBloc, SignUpBloc, HomeBloc, BuildContext])
import 'login_screen_test.mocks.dart';

void main() {
  late MockLoginBloc mockLoginBloc;
  late MockSignUpBloc mockSignUpBloc;
  late MockHomeBloc mockHomeBloc;
  late MockBuildContext mockContext;
  late StreamController<LoginState> loginStateController;
  late StreamController<SignupState> signupStateController;
  late StreamController<HomeState> homeStateController;

  setUp(() {
    mockLoginBloc = MockLoginBloc();
    mockSignUpBloc = MockSignUpBloc();
    mockHomeBloc = MockHomeBloc();
    mockContext = MockBuildContext();

    // Stream controller for LoginBloc
    loginStateController = StreamController<LoginState>.broadcast();
    when(mockLoginBloc.stream).thenAnswer((_) => loginStateController.stream);
    when(mockLoginBloc.state).thenReturn(LoginState.initial());

    // Stream controller for SignUpBloc
    signupStateController = StreamController<SignupState>.broadcast();
    when(mockSignUpBloc.stream).thenAnswer((_) => signupStateController.stream);
    when(mockSignUpBloc.state).thenReturn(const SignupState.initial());

    // Stream controller for HomeBloc
    homeStateController = StreamController<HomeState>.broadcast();
    when(mockHomeBloc.stream).thenAnswer((_) => homeStateController.stream);
    when(mockHomeBloc.state).thenReturn(const HomeState(
      selectedIndex: 0, // Required parameter
      views: [], // Required parameter (empty list as placeholder)
    ));
  });

  tearDown(() {
    loginStateController.close();
    signupStateController.close();
    homeStateController.close();
  });

  Widget buildTestWidget() {
    return MaterialApp(
      home: MultiBlocProvider(
        providers: [
          BlocProvider<LoginBloc>.value(value: mockLoginBloc),
          BlocProvider<SignUpBloc>.value(value: mockSignUpBloc),
          BlocProvider<HomeBloc>.value(value: mockHomeBloc),
        ],
        child: LoginScreen(),
      ),
    );
  }

  testWidgets('LoginScreen renders initial UI correctly',
      (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget());
    await tester.pumpAndSettle();

    expect(find.text('Welcome Back!'), findsOneWidget);
    expect(find.text('Login to continue'), findsOneWidget);
    expect(find.byType(TextField), findsNWidgets(2)); // Email and Password
    expect(find.text('Login'), findsOneWidget);
    expect(find.text('Sign Up'), findsOneWidget);
  });

  testWidgets('LoginScreen triggers LoginUserEvent on login button tap',
      (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget());
    await tester.pumpAndSettle();

    // Enter text into TextFields
    await tester.enterText(find.byType(TextField).first, 'test@example.com');
    await tester.enterText(find.byType(TextField).last, 'password');
    await tester.tap(find.text('Login'));
    await tester.pump();

    // Verify the event with a matcher
    verify(mockLoginBloc.add(argThat(isA<LoginUserEvent>()
            .having((e) => e.email, 'email', 'test@example.com')
            .having((e) => e.password, 'password', 'password')
            .having((e) => e.context, 'context', isA<BuildContext>()))))
        .called(1);
  });

  testWidgets('LoginScreen navigates to SignUp on sign-up button tap',
      (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Sign Up'));
    await tester.pump();

    // Verify the event with a matcher
    verify(mockLoginBloc.add(argThat(isA<NavigateSignupScreenEvent>()
            .having((e) => e.destination, 'destination', isA<SignUp>())
            .having((e) => e.context, 'context', isA<BuildContext>()))))
        .called(1);
  });
}
