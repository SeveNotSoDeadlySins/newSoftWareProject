import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? _user;
  User? get user => _user;

  AuthService() {
    _auth.authStateChanges().listen((User? user) {
      _user = user;
      notifyListeners();
    });
  }

  //  Sign Up with Firestore and Send Email Verification
  Future<String?> signUpWithEmail(
      String email, String password, String username) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      //  Send Email Verification
      await userCredential.user!.sendEmailVerification();

      //  Store additional user data in Firestore
      await _firestore.collection("users").doc(userCredential.user!.uid).set({
        "uid": userCredential.user!.uid,
        "username": username,
        "email": email,
        "isVerified": false, // Track verification status
        "createdAt": DateTime.now(),
      });

      return "Verification email sent. Please verify your email.";
    } catch (err) {
      print("Error: $err");
      return "Error: $err";
    }
  }

  //  Login with Email (Check if Email is Verified)
  Future<String?> loginWithEmail(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      //  Check if email is verified
      if (!userCredential.user!.emailVerified) {
        await _auth.signOut(); // Log them out immediately
        return "Please verify your email before logging in.";
      }

      //  Store locally for session management
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_id', userCredential.user!.uid);

      _user = userCredential.user;
      notifyListeners();

      return "Success"; // Login successful
    } catch (err) {
      print("Error: $err");
      return "Error: $err";
    }
  }

  //  Check if Email is Verified
  Future<bool> isEmailVerified() async {
    User? user = _auth.currentUser;
    await user?.reload(); // Refresh user data
    return user?.emailVerified ?? false;
  }

  //  Resend Verification Email
  Future<String?> resendVerificationEmail() async {
    try {
      User? user = _auth.currentUser;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
        return "Verification email resent. Check your inbox.";
      }
      return "User is already verified or not logged in.";
    } catch (err) {
      print("Error: $err");
      return "Error: $err";
    }
  }

  //  Logout
  Future<void> logout() async {
    await _auth.signOut();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_id'); // Clear local user ID
    _user = null;
    notifyListeners();
  }
}
