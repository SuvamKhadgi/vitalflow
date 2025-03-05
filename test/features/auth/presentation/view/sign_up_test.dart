import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:vitalflow/features/auth/presentation/view/sign_up.dart';
import 'package:vitalflow/features/auth/presentation/view_model/login/login_bloc.dart';
// import 'package:vitalflow/features/auth/presentation/view_model/login/login_state.dart';
import 'package:vitalflow/features/auth/presentation/view_model/signup/signup_bloc.dart';
// import 'package:vitalflow/features/auth/presentation/view_model/signup/signup_state.dart';
import 'package:vitalflow/features/home/presentation/view_model/home_bloc.dart';
import 'package:vitalflow/features/home/presentation/view_model/home_state.dart';

// Mock classes
@GenerateMocks([SignUpBloc, LoginBloc, HomeBloc, BuildContext])
import 'sign_up_test.mocks.dart';

void main() {
  late MockSignUpBloc mockSignUpBloc;
  late MockLoginBloc mockLoginBloc;
  late MockHomeBloc mockHomeBloc;
  late StreamController<SignupState> signupStateController;
  late StreamController<LoginState> loginStateController;
  late StreamController<HomeState> homeStateController;

  setUp(() {
    mockSignUpBloc = MockSignUpBloc();
    mockLoginBloc = MockLoginBloc();
    mockHomeBloc = MockHomeBloc();

    signupStateController = StreamController<SignupState>.broadcast();
    loginStateController = StreamController<LoginState>.broadcast();
    homeStateController = StreamController<HomeState>.broadcast();

    when(mockSignUpBloc.stream).thenAnswer((_) => signupStateController.stream);
    when(mockSignUpBloc.state).thenReturn(const SignupState.initial());

    when(mockLoginBloc.stream).thenAnswer((_) => loginStateController.stream);
    when(mockLoginBloc.state).thenReturn(LoginState.initial());

    when(mockHomeBloc.stream).thenAnswer((_) => homeStateController.stream);
    when(mockHomeBloc.state).thenReturn(const HomeState(
      selectedIndex: 0,
      views: [],
    ));
  });

  tearDown(() {
    signupStateController.close();
    loginStateController.close();
    homeStateController.close();
  });

  Widget buildTestWidget() {
    return MaterialApp(
      home: MultiBlocProvider(
        providers: [
          BlocProvider<SignUpBloc>.value(value: mockSignUpBloc),
          BlocProvider<LoginBloc>.value(value: mockLoginBloc),
          BlocProvider<HomeBloc>.value(value: mockHomeBloc),
        ],
        child: const SignUp(),
      ),
    );
  }

  testWidgets('SignUp renders initial UI correctly',
      (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget());
    await tester.pumpAndSettle();

    expect(find.text('Create Your Account'), findsOneWidget);
    expect(find.text('Sign up to get started'), findsOneWidget);
    expect(find.byType(TextField), findsNWidgets(4));
    expect(find.byType(TextFormField), findsNWidgets(3));
    expect(find.text('Sign Up'), findsOneWidget);
    expect(find.text('Sign In'), findsOneWidget);
  });

  testWidgets('SignUp triggers SignupUser event on sign-up button tap',
      (WidgetTester tester) async {
    tester.binding.window.physicalSizeTestValue = const Size(800, 1200);
    tester.binding.window.devicePixelRatioTestValue = 1.0;

    await tester.pumpWidget(buildTestWidget());
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).at(0), 'Test User');
    await tester.enterText(
        find.byKey(const ValueKey('email')), 'test@example.com');
    await tester.enterText(find.byKey(const ValueKey('password')), 'password');
    await tester.enterText(find.byType(TextFormField).last, 'password');

    await tester.drag(
        find.byType(SingleChildScrollView), const Offset(0, -300));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Sign Up'));
    await tester.pump();

    verify(mockSignUpBloc.add(argThat(isA<SignupUser>()
            .having((e) => e.name, 'name', 'Test User')
            .having((e) => e.email, 'email', 'test@example.com')
            .having((e) => e.password, 'password', 'password')
            .having((e) => e.context, 'context', isA<BuildContext>())
            .having((e) => e.image, 'image', null))))
        .called(1);

    tester.binding.window.clearPhysicalSizeTestValue();
  });

  testWidgets('SignUp opens bottom sheet on CircleAvatar tap',
      (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget());
    await tester.pumpAndSettle();

    await tester.tap(find.byType(CircleAvatar));
    await tester.pumpAndSettle();

    expect(find.text('Camera'), findsOneWidget);
    expect(find.text('Gallery'), findsOneWidget);
  });
}
