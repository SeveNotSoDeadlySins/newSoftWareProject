import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import '../games/litter_catcher_game.dart';
import '../widgets/pause_menu.dart';

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
            },
            initialActiveOverlays: const [],
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
          Positioned(
            bottom: 20,
            left: 20,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const EcoMatchScreen()),
                );
              },
              child: const Text('Play Eco Match'),
            ),
          ),
        ],
      ),
    );
  }
}
