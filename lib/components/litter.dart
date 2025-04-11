import 'package:flame/components.dart';
import '../games/litter_catcher_game.dart';
import 'package:flutter/material.dart';

class Litter extends SpriteComponent with HasGameRef<LitterCatcherGame> {
  final double speed = 150;
  final VoidCallback? onMissed;

  Litter({this.onMissed}) : super(size: Vector2(32, 32), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    sprite = await gameRef.loadSprite('litter1.png');
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.y += speed * dt;

    // Missed the player
    if (position.y > gameRef.size.y) {
      onMissed?.call(); // Trigger game miss logic
      removeFromParent();
    }

    // Caught by player
    if (gameRef.player.toRect().overlaps(toRect())) {
      gameRef.increaseScore();
      removeFromParent();
    }
  }
}
