// import 'package:flame/game.dart';
// import 'package:flame/events.dart';
// import 'package:flame/components.dart';
// import 'package:new_project/games/draggable_word.dart';

// class SentenceGame extends FlameGame with DragCallbacks {
//   final List<Map<String, dynamic>> wordsData;

//   SentenceGame(this.wordsData);

//   @override
//   Future<void> onLoad() async {
//     // Load draggable words
//     for (var data in wordsData) {
//       final word = data['word'] as String;
//       final xPos = data['x'] as double;
//       final yPos = data['y'] as double;

//       add(DraggableWord(
//         word,
//         Vector2(50, 400), // Starting position
//         Vector2(xPos, yPos), // Correct position
//       ));
//     }
//   }
// }
