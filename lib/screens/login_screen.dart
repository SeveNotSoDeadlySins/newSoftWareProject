import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:new_project/services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isLoading = false;

  // Reusable styled input
  Widget _buildInputField({
    required String hint,
    required TextEditingController controller,
    bool obscure = false,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscure,
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.grey),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF9900FF), // Purple background
      appBar: AppBar(
        backgroundColor: const Color(0xFF9900FF),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text("Login", style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildInputField(
              hint: "Email",
              controller: emailController,
            ),
            _buildInputField(
              hint: "Password",
              controller: passwordController,
              obscure: true,
            ),
            const SizedBox(height: 20),
            isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : ElevatedButton(
                    onPressed: () async {
                      setState(() => isLoading = true);

                      final authService =
                          Provider.of<AuthService>(context, listen: false);
                      final result = await authService.loginWithEmail(
                        emailController.text.trim(),
                        passwordController.text.trim(),
                      );

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(result ?? "Login Failed"),
                          backgroundColor: result!.contains("Success")
                              ? Colors.green
                              : Colors.red,
                        ),
                      );

                      setState(() => isLoading = false);

                      if (result == "Success") {
                        Navigator.pushReplacementNamed(context, "/home");
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF7F00FF), // Deep purple
                      foregroundColor: Colors.white, // Text color
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                        side: const BorderSide(color: Colors.black), // Outline
                      ),
                      elevation: 6,
                      shadowColor: Colors.black,
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                    child: const Text("Login"),
                  ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () async {
                final authService =
                    Provider.of<AuthService>(context, listen: false);
                final result = await authService.resendVerificationEmail();

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(result ?? "Error"),
                    backgroundColor: Colors.blue,
                  ),
                );
              },
              child: const Text(
                "Resend Verification Email",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
