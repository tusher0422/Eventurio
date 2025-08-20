import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../widgets/eventurio_icon.dart';
import 'login_screen.dart';

class SignupScreen extends StatelessWidget {
  SignupScreen({super.key});

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthController authController = AuthController.to;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF2575FC), Color(0xFF6A11CB)],
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
                  "Create Account",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 30),
                TextField(
                  controller: nameController,
                  style: const TextStyle(color: Colors.white),
                  decoration: _inputDecoration("Full Name"),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: emailController,
                  style: const TextStyle(color: Colors.white),
                  decoration: _inputDecoration("Email"),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  style: const TextStyle(color: Colors.white),
                  decoration: _inputDecoration("Password"),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.deepPurple,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12))),
                    onPressed: () {
                      authController.signUp(
                        name: nameController.text.trim(),
                        email: emailController.text.trim(),
                        password: passwordController.text.trim(),
                      );
                    },
                    child: const Text("Sign Up"),
                  ),
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    Get.to(() => LoginScreen());
                  },
                  child: const Text(
                    "Already have an account? Login",
                    style: TextStyle(color: Colors.white70),
                  ),
                )
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
