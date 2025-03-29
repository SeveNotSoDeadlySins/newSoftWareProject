import 'package:flame/game.dart';
import 'package:flame/components.dart';
import '../components/player.dart';
import '../components/litter.dart';
import '../components/background.dart';

class LitterCatcherGame extends FlameGame with HasCollisionDetection {
  late Player player;
  late Timer litterTimer;
  final String controlMode;

  bool soundOn = true;
  bool vibrationOn = true;
  int score = 0;

  LitterCatcherGame({required this.controlMode});

  @override
  Future<void> onLoad() async {
    await images.loadAll([
      'player.png',
      'litter1.png',
      'bg.png',
    ]);

    add(Background());

    player = Player(controlMode: controlMode);
    add(player);

    litterTimer = Timer(1.2, onTick: spawnLitter, repeat: true)..start();
  }

  @override
  void update(double dt) {
    super.update(dt);
    litterTimer.update(dt);
  }

  void spawnLitter() {
    final litter = Litter()
      ..position = Vector2.random()
      ..x *= size.x
      ..y = -30;
    add(litter);
  }

  void increaseScore() {
    score++;
    print('Score: $score');
  }

  void pauseGame() {
    pauseEngine();
    overlays.add('PauseMenu');
    overlays.remove('PauseButton');
  }

  void resumeGame() {
    overlays.remove('PauseMenu');
    overlays.add('PauseButton');
    resumeEngine();
  }

  // ✅ Settings logic for toggles
  void toggleSound(bool value) {
    soundOn = value;
    print('Sound: $soundOn');
  }

  void toggleVibration(bool value) {
    vibrationOn = value;
    print('Vibration: $vibrationOn');
  }

  void switchControl(String newMode) {
    player.controlMode = newMode;
  }
}
