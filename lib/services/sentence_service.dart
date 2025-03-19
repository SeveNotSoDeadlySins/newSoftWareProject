import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

class SentenceService {
  final _firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>?> fetchRandomSentence() async {
    try {
      final snapshot = await _firestore.collection('sentences').get();
      if (snapshot.docs.isEmpty) return null;

      final randomDoc = snapshot.docs[Random().nextInt(snapshot.docs.length)];
      return randomDoc.data();
    } catch (e) {
      print("Error fetching sentence: $e");
      return null;
    }
  }
}
