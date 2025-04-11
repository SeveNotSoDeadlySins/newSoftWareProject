import 'package:flame/components.dart';

class Background extends SpriteComponent {
  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load('bg.png');
    size = Vector2(1000, 1000); // adjust as needed
    position = Vector2.zero();
  }
}
