import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:new_project/services/auth_service.dart';

class WaitingVerificationScreen extends StatefulWidget {
  @override
  _WaitingVerificationScreenState createState() =>
      _WaitingVerificationScreenState();
}

class _WaitingVerificationScreenState extends State<WaitingVerificationScreen> {
  Timer? _timer;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _startVerificationCheck();
  }

  void _startVerificationCheck() {
    _timer = Timer.periodic(Duration(seconds: 5), (timer) async {
      final authService = Provider.of<AuthService>(context, listen: false);
      bool isVerified = await authService.isEmailVerified();

      if (isVerified) {
        _timer?.cancel(); // Stop checking
        Navigator.pushReplacementNamed(context, "/home"); // Go to home page
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Waiting for Email Verification")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.email, size: 100, color: Colors.blue),
            SizedBox(height: 20),
            Text(
              "A verification email has been sent to your email. Please verify before continuing.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        isLoading = true;
                      });

                      final authService =
                          Provider.of<AuthService>(context, listen: false);
                      String? result =
                          await authService.resendVerificationEmail();

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(result ?? "Error resending email"),
                          backgroundColor: Colors.blue,
                        ),
                      );

                      setState(() {
                        isLoading = false;
                      });
                    },
                    child: Text("Resend Verification Email"),
                  ),
            SizedBox(height: 20),
            Text("Checking email verification status every 5 seconds..."),
          ],
        ),
      ),
    );
  }
}
