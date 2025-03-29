import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/card_pair.dart';

class CardDataService {
  Future<List<CardPair>> fetchPairs() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('eco_pairs').get();
    return snapshot.docs
        .map((doc) => CardPair.fromFirestore(doc.data()))
        .toList();
  }
}
