import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flame/text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
  int coinsEarned = 0;
  int missedCount = 0;

  late TextComponent scoreText;

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

    // Score display
    scoreText = TextComponent(
      text: 'score: 0',
      position: Vector2(20, 50),
      priority: 10, // put it on the top layer
      anchor: Anchor.topLeft,
      textRenderer: TextPaint(
          style: const TextStyle(
              color: Color.fromARGB(255, 2, 2, 2), fontSize: 24)),
    );
    add(scoreText);

    litterTimer = Timer(1.2, onTick: spawnLitter, repeat: true)..start();
  }

  @override
  void update(double dt) {
    super.update(dt);
    litterTimer.update(dt);
  }

  void spawnLitter() {
    final litter = Litter(onMissed: handleMiss);
    litter
      ..position = Vector2.random()
      ..x *= size.x
      ..y = -30;
    add(litter);
  }

  void increaseScore() {
    score++;
    scoreText.text = 'Score: $score';

    if (score % 10 == 0) {
      coinsEarned += 5;
    }
  }

  void handleMiss() {
    missedCount++;
    if (missedCount >= 3) {
      endGame();
    }
  }

  void endGame() async {
    pauseEngine();
    overlays.add('GameOver');

    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = FirebaseFirestore.instance.collection('users').doc(user.uid);
      final snap = await doc.get();
      int currentCoins = snap.data()?['coins'] ?? 0;

      await doc.update({
        'coins': currentCoins + coinsEarned,
      });
    }

    print('Game Over! Score: $score, Coins Earned: $coinsEarned');
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

  void resetGame() {
    score = 0;
    coinsEarned = 0;
    missedCount = 0;
    scoreText.text = 'Score: 0';
    resumeEngine();
    overlays.remove('GameOver');
  }
}
