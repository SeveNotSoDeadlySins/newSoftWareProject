import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:new_project/games/my_game.dart';
import 'package:new_project/services/game_service.dart';

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late Future<Map<String, dynamic>?> gameData;
  MyGame? myGame;
  bool isPaused = false; // Track if game is paused

  @override
  void initState() {
    super.initState();
    gameData = GameService().fetchParagraph();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Map<String, dynamic>?>(
        future: gameData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || snapshot.data == null) {
            return Center(child: Text("Failed to load game data"));
          }

          myGame = MyGame(snapshot.data!);

          return Stack(
            children: [
              GameWidget(game: myGame!),

              // Pause button (Top-right corner)
              Positioned(
                top: 20,
                right: 20,
                child: IconButton(
                  icon: Icon(Icons.pause, color: Colors.white, size: 40),
                  onPressed: () {
                    setState(() => isPaused = true);
                    myGame?.pauseGame();
                  },
                ),
              ),

              // Pause Menu (Only visible when paused)
              if (isPaused)
                Positioned.fill(
                  child: Center(
                    child: Material(
                      color:
                          Colors.black.withOpacity(0.7), // Background overlay
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              setState(() => isPaused = false);
                              myGame?.resumeGame();
                            },
                            child: Text("Resume"),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pushReplacementNamed(context, '/home');
                            },
                            child: Text("Home"),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              // Future Settings Menu
                            },
                            child: Text("Settings"),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

              // Drag words at the bottom
              Positioned(
                bottom: 20,
                left: 0,
                right: 0,
                child: Wrap(
                  spacing: 10, // Space between words
                  runSpacing: 10, // Space between rows if wrapping occurs
                  children: myGame!.draggableWords.map((word) {
                    return Draggable<String>(
                      data: word.word,
                      feedback: Material(
                        color: Colors.transparent,
                        child: Text(
                          word.word,
                          style: TextStyle(
                              fontSize: 24,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      child: Container(
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          word.word,
                          style: TextStyle(fontSize: 24, color: Colors.white),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
