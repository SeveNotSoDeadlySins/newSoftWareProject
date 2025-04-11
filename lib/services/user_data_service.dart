import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserDataService {
  Future<String> getEquippedBackground() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return "default_bg"; // fallback

    final userDoc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    final equipped = userDoc.data()?['equipped'] ?? {};
    final bgId = equipped['background'];

    if (bgId == null) return "default_bg";

    // Lookup item in shop_items
    final query = await FirebaseFirestore.instance
        .collection('shop_items')
        .where('id', isEqualTo: bgId)
        .limit(1)
        .get();

    if (query.docs.isEmpty) return "default_bg";

    return query.docs.first.data()['image'] ??
        "default_bg"; // like "galaxy.png"
  }
}
