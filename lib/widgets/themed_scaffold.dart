import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ThemedScaffold extends StatelessWidget {
  final Widget child;

  const ThemedScaffold({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get(),
      builder: (context, snapshot) {
        String background = "default_bg"; // Default background

        if (snapshot.hasData) {
          var userDoc = snapshot.data;
          // Set the background from user's 'equipped' data if available
          background = userDoc?.get('equipped.background') ?? "default_bg";
        }

        return Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/backgrounds/$background.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: child,
        );
      },
    );
  }
}
