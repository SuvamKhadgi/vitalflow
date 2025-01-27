import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vitalflow/features/auth/presentation/view/login_screen.dart';
import 'package:vitalflow/features/auth/presentation/view_model/signup/signup_bloc.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {


  final _key = GlobalKey<FormState>();
  final _gap = const SizedBox(height: 8);

  // final _fnameController = TextEditingController(text: 'suvam');
  final _fnameController = TextEditingController();
  // final _lnameController = TextEditingController(text: 'khadgi');
  // final _phoneController = TextEditingController(text: '123456789');
  // final _emailController = TextEditingController(text: 'suvam');
  final _emailController = TextEditingController();
  // final _passwordController = TextEditingController(text: 'suvam123');
  final _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 124, 187, 238),
              Colors.lightBlueAccent
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Form(
          key: _key,
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Logo and Welcome Text
                    Center(
                      child: Column(
                        children: [
                          Image.asset(
                            'assets/images/logos.png',
                            width: 150,
                            height: 150,
                            fit: BoxFit.cover,
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            "Create Your Account",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 5),
                          const Text(
                            "Sign up to get started",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Name Field
                    TextField(
                      controller: _fnameController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        labelText: 'Name',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                        prefixIcon:
                            const Icon(Icons.person, color: Colors.blue),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Email Field
                    TextFormField(
                      key: const ValueKey('email'),
                      controller: _emailController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        labelText: 'Email',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                        prefixIcon: const Icon(Icons.email, color: Colors.blue),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter email';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),

                    // Password Field
                    TextFormField(
                      key: const ValueKey('password'),
                      controller: _passwordController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        labelText: 'Password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                        prefixIcon: const Icon(Icons.lock, color: Colors.blue),
                      ),
                      validator: ((value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter password';
                        }
                        return null;
                      }
                          // obscureText: true,
                          ),
                    ),
                    //  const SizedBox(height: 16),
                    _gap,

                    // Confirm Password Field
                    TextFormField(
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        labelText: 'Confirm Password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                        prefixIcon:
                            const Icon(Icons.lock_outline, color: Colors.blue),
                      ),
                      obscureText: true,
                    ),
                    const SizedBox(height: 30),

                    // Sign-Up Button
                    ElevatedButton(
                      onPressed: () {
                        if (_key.currentState!.validate()) {
                          context.read<SignUpBloc>().add(
                                SignupUser(
                                  context: context,
                                  name: _fnameController.text,
                                  email: _emailController.text,
                                  password: _passwordController.text,
                                ),
                              );
                        }
                        // _showSuccessSnackbar(context);
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Colors.white,
                      ),
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Already Have an Account Link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Already have an account? ",
                          style: TextStyle(color: Colors.white),
                        ),
                        TextButton(
                          onPressed: () {
                            context.read<SignUpBloc>().add(
                                  NavigateloginScreenEvent(
                                    destination: LoginScreen(),
                                    context: context,
                                  ),
                                );
                          },
                          child: const Text(
                            'Sign In',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
