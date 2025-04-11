import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:sensors_plus/sensors_plus.dart';
import '../games/litter_catcher_game.dart';

class Player extends SpriteComponent
    with HasGameRef<LitterCatcherGame>, DragCallbacks {
  late String controlMode;
  StreamSubscription? _sensorSubscription;
  final double moveSpeed = 200;

  double _tiltX = 0;

  Player({required this.controlMode})
      : super(size: Vector2(100, 100), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    sprite = await gameRef.loadSprite('player.png');
    position = Vector2(gameRef.size.x / 2, gameRef.size.y - 80);

    if (controlMode == 'tilt') {
      _sensorSubscription = accelerometerEvents.listen((event) {
        _tiltX = event.x;
      });
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (controlMode == 'tilt') {
      final dx = -_tiltX * 300 * dt;
      position.x += dx;
      position.x = position.x.clamp(32, gameRef.size.x - 32);
    }
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    if (controlMode == 'drag') {
      position.x += event.delta.x;
      position.x = position.x.clamp(32, gameRef.size.x - 32);
    }
  }

  @override
  void onRemove() {
    _sensorSubscription?.cancel();
    super.onRemove();
  }
}
