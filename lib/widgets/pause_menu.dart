import 'package:flutter/material.dart';
import '../games/litter_catcher_game.dart';

class PauseMenu extends StatelessWidget {
  final LitterCatcherGame game;

  const PauseMenu({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 24),
        color: Colors.white.withOpacity(0.95),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Paused',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              SwitchListTile(
                title: const Text('Sound'),
                value: game.soundOn,
                onChanged: game.toggleSound,
              ),
              SwitchListTile(
                title: const Text('Vibration'),
                value: game.vibrationOn,
                onChanged: game.toggleVibration,
              ),
              DropdownButton<String>(
                value: game.controlMode,
                items: const [
                  DropdownMenuItem(value: 'drag', child: Text('Drag')),
                  DropdownMenuItem(value: 'tilt', child: Text('Tilt')),
                ],
                onChanged: (val) {
                  if (val != null) game.switchControl(val);
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => game.resumeGame(),
                child: const Text('Resume'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  game.overlays.clear();
                  game.resumeEngine();
                  Navigator.popUntil(context, ModalRoute.withName('/home'));
                },
                child: const Text('Return to Home'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
