import 'package:flutter/material.dart';

class GameOverOverlay extends StatelessWidget {
  final int score;
  final int coins;
  final VoidCallback onRestart;

  const GameOverOverlay({
    super.key,
    required this.score,
    required this.coins,
    required this.onRestart,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Game Over",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Text("Score: $score", style: const TextStyle(fontSize: 20)),
            Text("Coins Earned: $coins", style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: onRestart,
              child: const Text("Play Again"),
            ),
          ],
        ),
      ),
    );
  }
}
