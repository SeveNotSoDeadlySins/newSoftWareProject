import 'package:flame/game.dart';
import 'package:new_project/games/paragraph_component.dart';
import 'package:new_project/games/draggable_word.dart';

class MyGame extends FlameGame {
  late ParagraphComponent paragraph;
  late List<DraggableWord> draggableWords;
  final Map<String, dynamic> gameData;
  bool isPaused = false; // Track pause state

  MyGame(this.gameData);

  @override
  Future<void> onLoad() async {
    String text = gameData['text'];
    List<String> missingWords = List<String>.from(gameData['words']);

    paragraph = ParagraphComponent(text, missingWords);
    paragraph.position = Vector2(50, 100);
    add(paragraph);

    draggableWords = missingWords
        .asMap()
        .entries
        .map((entry) =>
            DraggableWord(entry.value, Vector2(100 * (entry.key + 1), 400)))
        .toList();

    for (var word in draggableWords) {
      add(word);
    }
  }

  void pauseGame() {
    isPaused = true;
    pauseEngine();
  }

  void resumeGame() {
    isPaused = false;
    resumeEngine();
  }
}
