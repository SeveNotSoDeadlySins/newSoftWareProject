import 'package:flame/game.dart';
import 'package:flame/components.dart';
import '../models/card_pair.dart';
import '../services/card_data_service.dart';
import '../components/draggable_card.dart';
import '../components/bin_target.dart';

class EcoMatchGame extends FlameGame with HasCollisionDetection {
  final _service = CardDataService();
  late List<CardPair> _pairs;

  @override
  Future<void> onLoad() async {
    _pairs = await _service.fetchPairs();

    // Preload all images
    await images
        .loadAll(_pairs.expand((e) => [e.itemImage, e.binImage]).toList());

    // Spawn cards into the game
    spawnCards(_pairs);
  }

  void onMatchSuccess(String matchKey, String fact) {
    print("✅ Matched: $matchKey");
    print("🌱 Fun Fact: $fact");

    // You can add an overlay later to show the fact visually
  }

  void spawnCards(List<CardPair> pairs) {
    final startX = 100.0;
    final binY = size.y - 100;

    for (int i = 0; i < pairs.length; i++) {
      final pair = pairs[i];

      final item = DraggableCardComponent(
        sprite: Sprite(images.fromCache(pair.itemImage)),
        position: Vector2(startX + i * 80, 100),
        matchKey: pair.match,
        funFact: pair.fact,
      );

      final bin = BinTargetComponent(
        sprite: Sprite(images.fromCache(pair.binImage)),
        position: Vector2(startX + i * 80, binY),
        matchKey: pair.match,
      );

      addAll([item, bin]);
    }
  }
}
