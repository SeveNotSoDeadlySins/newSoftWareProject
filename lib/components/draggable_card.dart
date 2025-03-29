import 'package:flame/components.dart';
import 'package:flame/events.dart';
import '../games/eco_match_game.dart';

class DraggableCardComponent extends SpriteComponent
    with DragCallbacks, HasGameRef<EcoMatchGame> {
  final String matchKey;
  final String funFact;

  Vector2 _startPos = Vector2.zero();

  DraggableCardComponent({
    required Sprite sprite,
    required Vector2 position,
    required this.matchKey,
    required this.funFact,
  }) : super(
          sprite: sprite,
          size: Vector2.all(64),
          position: position,
          anchor: Anchor.center,
        );

  @override
  void onDragStart(DragStartEvent event) {
    _startPos = position.clone(); // Save original position
    super.onDragStart(event);
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    position += event.delta;
    super.onDragUpdate(event);
  }

  @override
  void onDragEnd(DragEndEvent event) {
    final hit = gameRef.children.whereType<BinTargetComponent>().firstWhere(
          (bin) => bin.toRect().overlaps(toRect()),
          orElse: () => null,
        );

    if (hit != null && hit.matchKey == matchKey) {
      gameRef.onMatchSuccess(matchKey, funFact);
      removeFromParent(); // remove card on success
    } else {
      // Reset to original spot
      position.setFrom(_startPos);
    }
    super.onDragEnd(event);
  }
}
