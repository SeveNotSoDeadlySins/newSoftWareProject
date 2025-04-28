import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/card_pair.dart';

class CardDataService {
  Future<List<CardPair>> fetchPairs({int count = 3}) async {
    // Fetch level_1 from eco_pairs
    final doc = await FirebaseFirestore.instance
        .collection('eco_pairs')
        .doc('level_1')
        .get();

    final data = doc.data();
    if (data == null || !data.containsKey('items')) return [];

    final items = List<Map<String, dynamic>>.from(data['items']);
    final allPairs = items.map((item) => CardPair.fromMap(item)).toList();

    allPairs.shuffle(); // Randomize order

    // Return only `count` number of pairs, or all if fewer exist
    return allPairs.take(count).toList();
  }
}
