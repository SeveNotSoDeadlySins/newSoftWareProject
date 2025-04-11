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

      await userCredential.user!.sendEmailVerification();

      // Store additional user data in Firestore with game fields
      await _firestore.collection("users").doc(userCredential.user!.uid).set({
        "uid": userCredential.user!.uid,
        "username": username,
        "email": email,
        "isVerified": false,
        "createdAt": DateTime.now(),
        "coins": 0,
        "ownedItems": [], // or add some default ones if needed
        "equipped": {
          "background": "default_bg", // default value you’ll handle later
          "accessory": "none"
        }
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

      // Reload user to get latest emailVerified status
      await userCredential.user!.reload();
      final updatedUser = _auth.currentUser;

      if (updatedUser != null && updatedUser.emailVerified) {
        // ✅ Update isVerified to true in Firestore
        await _firestore.collection("users").doc(updatedUser.uid).update({
          "isVerified": true,
        });
      } else {
        await _auth.signOut(); // Log them out
        return "Please verify your email before logging in.";
      }

      // Save user session locally
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_id', updatedUser!.uid);

      _user = updatedUser;
      notifyListeners();

      return "Success";
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
