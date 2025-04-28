import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import '../games/litter_catcher_game.dart';
import '../widgets/pause_menu.dart';
import '../widgets/gmae_over_overlay.dart';

class GameScreen extends StatelessWidget {
  final String controlMode;

  const GameScreen({super.key, required this.controlMode});

  @override
  Widget build(BuildContext context) {
    final game = LitterCatcherGame(controlMode: controlMode);

    return Scaffold(
      body: Stack(
        children: [
          GameWidget(
            game: game,
            overlayBuilderMap: {
              'PauseMenu': (context, game) =>
                  PauseMenu(game: game as LitterCatcherGame),
              'GameOver': (context, game) {
                final g = game as LitterCatcherGame;
                return GameOverOverlay(
                  score: g.score,
                  coins: g.coinsEarned,
                  onRestart: () {
                    g.resetGame();
                    g.overlays.remove('GameOver');
                  },
                );
              },
              'PauseButton': (context, game) => SafeArea(
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: IconButton(
                          icon: const Icon(Icons.pause,
                              size: 32, color: Colors.black),
                          onPressed: () {
                            (game as LitterCatcherGame).pauseGame();
                          },
                        ),
                      ),
                    ),
                  ),
            },
            initialActiveOverlays: const ['PauseButton'],
          ),
          Align(
            alignment: Alignment.topRight,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: IconButton(
                  icon: const Icon(Icons.pause, color: Colors.black, size: 32),
                  onPressed: () {
                    game.pauseGame();
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
