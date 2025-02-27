import 'package:devwidget/core/feature/auth/view/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../commanwidget/commantextfiledwidget.dart';
import '../viewmodel/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool obscureText = true;
  final _formKey = GlobalKey<FormState>();

  void _togglePasswordVisibility() {
    setState(() {
      obscureText = !obscureText;
    });
  }

  void _login() {
    if (_formKey.currentState!.validate()) {
      ref.read(authProvider.notifier).login(
            emailController.text,
            passwordController.text,
            context,
          );
    }
  }

  void _googleSignIn() {
    ref.read(authProvider.notifier).googleSignIn(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Logo
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 20.h,
                      width: 20.w,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                              "assets/images/logo-no-background 1@2x.png"),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4.h),

                // Login Text
                Text(
                  "Login in",
                  style: TextStyle(
                    fontSize: 25.px,
                    color: const Color(0xff471AA0),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 2.h),

                // Email Field
                CommonTextFieldWidget(
                  controller: emailController,
                  hintText: "Email or Username",
                  prefixIcon: const Icon(Icons.person, color: Colors.purple),
                  borderColor: Colors.grey,
                  focusedBorderColor: Colors.blue,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                        .hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 5.h),

                // Password Field
                CommonTextFieldWidget(
                  controller: passwordController,
                  hintText: "Password",
                  obscureText: obscureText,
                  prefixIcon: const Icon(Icons.lock, color: Colors.purple),
                  suffixIcon: IconButton(
                    icon: Icon(
                      obscureText ? Icons.visibility_off : Icons.visibility,
                      color: Colors.black,
                    ),
                    onPressed: _togglePasswordVisibility,
                  ),
                  borderColor: Colors.grey,
                  focusedBorderColor: Colors.blue,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 3.h),

                // Forgot Password
                const Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "Forget Password?",
                      style: TextStyle(
                        color: Color(0xff471AA0),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2.h),

                // Login Button
                InkWell(
                  onTap: _login,
                  child: Container(
                    height: 8.h,
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                      color: const Color(0xffBB84E8),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Center(
                      child: Text(
                        "log in",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 5.h),

                // Or Sign in with Text
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Or Sign in with",
                      style: TextStyle(
                        color: Color(0xff471AA0),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2.h),

                // Google Sign-In Button
                InkWell(
                  onTap: _googleSignIn,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 5.h,
                        width: 5.h,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("assets/images/googlelogo.png"),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 7.h),

                // Don't Have an Account? Sign Up
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don't Have an account?",
                      style: TextStyle(
                        color: Color(0xff471AA0),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignupScreen()),
                        );
                      },
                      child: const Text(
                        "Sign Up",
                        style: TextStyle(
                          color: Color(0xff471AA0),
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
    );
  }
}
