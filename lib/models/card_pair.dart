class CardPair {
  final String item;
  final String match;
  final String fact;
  final String itemImage;
  final String binImage;

  CardPair({
    required this.item,
    required this.match,
    required this.fact,
    required this.itemImage,
    required this.binImage,
  });

  factory CardPair.fromMap(Map<String, dynamic> data) {
    return CardPair(
      item: data['item'],
      match: data['match'],
      fact: data['fact'],
      itemImage: data['itemImage'],
      binImage: data['binImage'],
    );
  }
}
