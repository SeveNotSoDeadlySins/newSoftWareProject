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
  double _difficultyMultiplier = 1.0; // NEW: controls speed and spawn intensity

  @override
  Future<void> onLoad() async {
    _pairs = await _service.fetchPairs();

    await images.loadAll(
      _pairs.expand((e) => [e.itemImage, e.binImage]).toList() + ['bg.png'],
    );

    final bg = SpriteComponent(
      sprite: await loadSprite('bg.png'),
      size: size,
      anchor: Anchor.topLeft,
    );
    add(bg);

    spawnCards(_pairs);
  }

  void onMatchSuccess(String matchKey, String fact) {
    _matchedCount++;

    // Increase difficulty every 3 matches
    if (_matchedCount % 3 == 0) {
      _difficultyMultiplier += 0.2;
    }

    if (_matchedCount >= _totalPairs) {
      givePlayerRewards();
      overlays.add('LevelComplete');
      pauseEngine();
    } else {
      maybeSpawnMoreTrash();
    }
  }

  void maybeSpawnMoreTrash() async {
    final newPairs = await _service.fetchPairs(count: 1);
    _pairs.addAll(newPairs);
    spawnCards(newPairs);
  }

  void givePlayerRewards() async {
    const earnedXP = 10;
    const earnedCoins = 5;

    final playerService = PlayerDataService();
    await playerService.addXP(earnedXP);
    await playerService.addCoins(earnedCoins);
  }

  void wrongMatch() {
    overlays.add('WrongOverlay');
    pauseEngine();
  }

  void spawnCards(List<CardPair> pairs) {
    const spacing = 100.0;
    const itemY = 150.0;
    final binY = size.y - 150;

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
        speed:
            100.0 * _difficultyMultiplier, // OPTIONAL: if you add speed support
      );
      add(item);

      if (!addedBins.contains(pair.match)) {
        final bin = BinTargetComponent(
          sprite: Sprite(images.fromCache(pair.binImage)),
          position: Vector2(startX + i * spacing, binY),
          matchKey: pair.match,
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
