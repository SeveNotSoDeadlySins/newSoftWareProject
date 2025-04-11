import 'package:flame/game.dart';
import 'package:flame/components.dart';
import '../models/card_pair.dart';
import '../services/card_data_service.dart';
import '../components/draggable_card.dart';
import '../components/bin_target.dart';
import '../services/player_data_service.dart';

class EcoMatchGame extends FlameGame with HasCollisionDetection {
  final _service = CardDataService();
  late List<CardPair> _pairs;

  int _totalPairs = 0;
  int _matchedCount = 0;

  @override
  Future<void> onLoad() async {
    _pairs = await _service.fetchPairs();

    // Preload all needed images (including bg)
    await images.loadAll(
      _pairs.expand((e) => [e.itemImage, e.binImage]).toList() + ['bg.png'],
    );

    // Add background first so it's drawn behind everything
    final bg = SpriteComponent(
      sprite: await loadSprite('bg.png'),
      size: size,
      anchor: Anchor.topLeft,
    );
    add(bg);

    // THEN add cards and bins
    spawnCards(_pairs);
  }

  void onMatchSuccess(String matchKey, String fact) {
    _matchedCount++;

    if (_matchedCount >= _totalPairs) {
      givePlayerRewards();
      overlays.add('LevelComplete');
      pauseEngine();
    }
  }

  void givePlayerRewards() async {
    const earnedCoins = 5;

    final playerService = PlayerDataService();
    await playerService.addCoins(earnedCoins);
  }

  void wrongMatch() {
    overlays.add('WrongOverlay');
    pauseEngine();
  }

  void spawnCards(List<CardPair> pairs) {
    _matchedCount = 0;
    _totalPairs = pairs.length;

    const spacing = 100.0;
    const itemY = 150.0;
    final binY = size.y - 150;

    // Center items across screen
    final totalWidth = (pairs.length - 1) * spacing;
    final startX = (size.x - totalWidth) / 2;

    final Set<String> addedBins = {};

    for (int i = 0; i < pairs.length; i++) {
      final pair = pairs[i];

      final item = DraggableCardComponent(
        sprite: Sprite(images.fromCache(pair.itemImage)),
        position: Vector2(startX + i * spacing, itemY),
        matchKey: pair.match,
        funFact: pair.fact,
        size: Vector2(120, 120), // Add this line to make it bigger
      );
      add(item);

      if (!addedBins.contains(pair.match)) {
        // Choose bin side: alternate or use index
        final isLeft = addedBins.isEmpty; // first bin goes left, second right

        final binX = isLeft ? size.x * 0.2 : size.x * 0.8;

        final bin = BinTargetComponent(
          sprite: Sprite(images.fromCache(pair.binImage)),
          position: Vector2(binX, binY),
          matchKey: pair.match,
          size: Vector2(150, 300),
        );
        add(bin);
        addedBins.add(pair.match);
      }
    }
  }

  void checkAnswers() {
    final cards = children.whereType<DraggableCardComponent>();

    final allCorrect = cards.every((card) => card.isInCorrectBin);

    if (allCorrect) {
      overlays.add('LevelComplete');
      pauseEngine();
    } else {
      overlays.add('WrongOverlay');
      pauseEngine();
    }
  }
}
