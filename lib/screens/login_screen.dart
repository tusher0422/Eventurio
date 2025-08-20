import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../widgets/eventurio_icon.dart';
import 'signup_screen.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final AuthController authController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const EventurioIcon(size: 120),
                const SizedBox(height: 20),
                const Text(
                  "Welcome Back",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 30),

                // Email
                TextField(
                  controller: emailController,
                  style: const TextStyle(color: Colors.white),
                  decoration: _inputDecoration("Email"),
                ),
                const SizedBox(height: 12),

                // Password
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  style: const TextStyle(color: Colors.white),
                  decoration: _inputDecoration("Password"),
                ),
                const SizedBox(height: 20),

                // Login Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.deepPurple,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      authController.login(
                        email: emailController.text.trim(),
                        password: passwordController.text.trim(),
                      );
                    },
                    child: const Text("Login"),
                  ),
                ),

                const SizedBox(height: 15),

                // Google Sign-In Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black87,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      authController.signInWithGoogle();
                    },
                    icon: Image.asset(
                      'assets/google_logo.png',
                      height: 24,
                      width: 24,
                    ),
                    label: const Text("Sign in with Google"),
                  ),
                ),

                const SizedBox(height: 20),

                // Go to Signup
                TextButton(
                  onPressed: () {
                    Get.to(() => SignupScreen());
                  },
                  child: const Text(
                    "Don’t have an account? Sign Up",
                    style: TextStyle(color: Colors.white70),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.white70),
      filled: true,
      fillColor: Colors.white24,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }
}
