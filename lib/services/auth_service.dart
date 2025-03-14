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

  // Sign Up with Firestore
  Future<String?> signUpWithEmail(
      String email, String password, String username) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // * Store additional user data in Firestore**
      await _firestore.collection("users").doc(userCredential.user!.uid).set({
        "uid": userCredential.user!.uid, // User's unique ID
        "username": username,
        "email": email,
        "createdAt": DateTime.now(),
      });

      // * Store locally for session management**
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_id', userCredential.user!.uid);

      _user = userCredential.user;
      notifyListeners();

      return "Success"; // Sign-up successful
    } catch (err) {
      print("Error: $err");
      return "Error: $err";
    }
  }

  // * Login with Email**
  Future<String?> loginWithEmail(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // * Store locally for session management**
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

  // * Logout**
  Future<void> logout() async {
    await _auth.signOut();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_id'); // Clear local user ID
    _user = null;
    notifyListeners();
  }
}
