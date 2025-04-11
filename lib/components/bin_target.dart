import 'package:flame/components.dart';

class BinTargetComponent extends SpriteComponent {
  final String matchKey;

  BinTargetComponent({
    required Sprite sprite,
    required Vector2 position,
    required this.matchKey,
  }) : super(
          sprite: sprite,
          position: position,
          size: Vector2.all(72),
          anchor: Anchor.center,
          priority: 1, // So it will be on top of the trash
        );
}
