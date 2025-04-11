import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import '../games/eco_match_game.dart';

class EcoMatchScreen extends StatelessWidget {
  const EcoMatchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final game = EcoMatchGame();

    return Scaffold(
      body: Stack(
        children: [
          GameWidget(
            game: game,
            overlayBuilderMap: {
              'LevelComplete': (context, _) => Center(
                    child: AlertDialog(
                      title: const Text("🎉 Congratulations!"),
                      content: const Text("You matched all items!"),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context); // Go back to home
                          },
                          child: const Text("Home"),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    const EcoMatchScreen(), // Reload level
                              ),
                            );
                          },
                          child: const Text("Play Again"),
                        ),
                      ],
                    ),
                  ),

              // ❌ Wrong Overlay (when the player gets a question wrong)
              'WrongOverlay': (context, _) => Center(
                    child: AlertDialog(
                      title: const Text("❌ Try Again!"),
                      content: const Text("That item doesn’t belong there."),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context); // Go back to home
                          },
                          child: const Text("Home"),
                        ),
                        TextButton(
                          onPressed: () {
                            // Remove the overlay and resume the game
                            Navigator.of(context).pop();
                            game.overlays.remove('WrongOverlay');
                            game.resumeEngine();
                          },
                          child: const Text("Try Again"),
                        ),
                      ],
                    ),
                  ),
            },
            initialActiveOverlays: const [], // Start without overlays
          ),

          // Top-right pause/back button
          Align(
            alignment: Alignment.topRight,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: IconButton(
                  icon: const Icon(Icons.pause, size: 32, color: Colors.black),
                  onPressed: () {
                    Navigator.pop(context); // Go back to home screen
                  },
                ),
              ),
            ),
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 40),
              child: ElevatedButton(
                onPressed: () {
                  game.checkAnswers();
                },
                child: const Text("✅ Check Answers"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
