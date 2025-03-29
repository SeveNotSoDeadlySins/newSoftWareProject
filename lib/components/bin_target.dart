import 'package:flame/components.dart';

class BinTargetComponent extends SpriteComponent {
  final String matchKey;

  BinTargetComponent({
    required Sprite sprite,
    required Vector2 position,
    required this.matchKey,
  }) : super(
          sprite: sprite,
          size: Vector2.all(80),
          position: position,
          anchor: Anchor.center,
        );
}
