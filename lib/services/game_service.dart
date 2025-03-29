import 'package:cloud_firestore/cloud_firestore.dart';

class GameService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>?> fetchParagraph() async {
    try {
      DocumentSnapshot snapshot =
          await _firestore.collection("game_data").doc("levels").get();

      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

        String rawText = data['text'];

        // Extract [word] using RegExp
        final RegExp regex = RegExp(r'\[(\w+)\]');
        final matches = regex.allMatches(rawText);

        final List<String> words =
            matches.map((match) => match.group(1)!).toList();

        final cleanText = rawText.replaceAllMapped(regex, (_) => "___");

        return {
          'text': cleanText,
          'words': words,
        };
      }
    } catch (e) {
      print("Error fetching paragraph: $e");
    }

    return null;
  }
}
