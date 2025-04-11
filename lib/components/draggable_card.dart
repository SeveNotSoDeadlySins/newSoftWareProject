import 'package:flame/components.dart';
import 'package:flame/events.dart';
import '../games/eco_match_game.dart';
import 'bin_target.dart';

class DraggableCardComponent extends SpriteComponent
    with DragCallbacks, HasGameRef<EcoMatchGame> {
  final String matchKey;
  final String funFact;

  bool isInCorrectBin = false; // Track if correct match

  late Vector2 _startPosition;

  DraggableCardComponent({
    required Sprite sprite,
    required Vector2 position,
    required this.matchKey,
    required this.funFact,
    Vector2? size, // add this
  }) : super(
          sprite: sprite,
          position: position,
          size: size ?? Vector2.all(80), // default if not passed
        );

  @override
  Future<void> onLoad() async {
    super.onLoad();
    _startPosition = position.clone();
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    position += event.localDelta;
  }

  @override
  void onDragEnd(DragEndEvent event) {
    BinTargetComponent? bin;

    try {
      bin = gameRef.children.whereType<BinTargetComponent>().firstWhere(
            (b) => b.matchKey == matchKey && b.toRect().overlaps(toRect()),
          );
    } catch (_) {
      bin = null;
    }

    isInCorrectBin = bin != null; // Store match status
  }

  void resetPosition() {
    position.setFrom(_startPosition);
    isInCorrectBin = false;
  }
}
