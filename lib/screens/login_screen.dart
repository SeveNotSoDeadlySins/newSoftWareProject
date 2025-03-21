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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: "Email"),
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: "Password"),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        isLoading = true;
                      });

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

                      setState(() {
                        isLoading = false;
                      });

                      if (result == "Success") {
                        Navigator.pushReplacementNamed(context, "/home");
                      }
                    },
                    child: const Text("Login"),
                  ),
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
              child: const Text("Resend Verification Email"),
            ),
          ],
        ),
      ),
    );
  }
}
