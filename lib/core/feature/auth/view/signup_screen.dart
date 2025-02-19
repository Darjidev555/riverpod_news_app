import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../commanwidget/commantextfiledwidget.dart';
import '../../../commanwidget/commantextwidget.dart';
import '../viewmodel/auth_provider.dart'; // Import your AuthController

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  bool obscureText = true;

  void _togglePasswordVisibility() {
    setState(() {
      obscureText = !obscureText;
    });
  }

  void _signup() {
    if (_formKey.currentState!.validate()) {
      final authController = ref.read(authProvider.notifier);

      // Call the register function from AuthController
      authController.register(
        emailController.text,
        passwordController.text,
        nameController.text,
        context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 100,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Row(
            children: [
              SizedBox(width: 20),
              Icon(Icons.arrow_back_ios),
              Padding(
                padding: EdgeInsets.only(left: 4.0),
                child: CommonTextWidget(
                  text: "Back",
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 3.h),
                // Sign Up Text
                CommonTextWidget(
                  text: "Sign Up",
                  fontSize: 25.px,
                  color: const Color(0xff471AA0),
                  fontWeight: FontWeight.bold,
                ),
                SizedBox(height: 3.h),

                // Full Name Field
                CommonTextFieldWidget(
                  controller: nameController,
                  hintText: "Full Name",
                  prefixIcon: const Icon(Icons.person, color: Colors.purple),
                  borderColor: Colors.grey,
                  focusedBorderColor: Colors.blue,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your full name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 3.h),

                // Email Field
                CommonTextFieldWidget(
                  controller: emailController,
                  hintText: "Email",
                  prefixIcon: const Icon(Icons.email, color: Colors.purple),
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
                SizedBox(height: 3.h),

                // Password Field with Visibility Toggle
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
                SizedBox(height: 5.h),

                // Sign Up Button
                InkWell(
                  onTap: _signup,
                  child: Container(
                    height: 8.h,
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                      color: const Color(0xffBB84E8),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Center(
                      child: CommonTextWidget(
                        text: "Sign Up",
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 22.h),

                // Already have an account? Sign In
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CommonTextWidget(
                      text: "Already have an account?",
                      color: Color(0xff471AA0),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: CommonTextWidget(
                        text: "Sign In",
                        color: const Color(0xff471AA0),
                        fontWeight: FontWeight.bold,
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
