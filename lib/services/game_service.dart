import 'package:cloud_firestore/cloud_firestore.dart';

class GameService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>?> fetchParagraph() async {
    try {
      DocumentSnapshot snapshot =
          await _firestore.collection("game_data").doc("paragraph1").get();

      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

        // Ensure 'words' is treated as a List
        if (data.containsKey('words') && data['words'] is String) {
          data['words'] = (data['words'] as String)
              .replaceAll(RegExp(r'[\[\]\"]'), '') // Remove brackets & quotes
              .split(', ') // Split into list
              .map((word) => word.trim()) // Trim spaces
              .toList();
        }

        return data;
      }
    } catch (e) {
      print("Error fetching paragraph: $e");
    }
    return null;
  }
}
