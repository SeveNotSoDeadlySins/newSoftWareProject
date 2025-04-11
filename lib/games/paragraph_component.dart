import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class ParagraphComponent extends PositionComponent {
  final String text;
  final List<String> missingWords;
  final Map<int, String> placedWords = {};
  final List<Vector2> blankPositions = [];

  final TextStyle style = const TextStyle(fontSize: 24, color: Colors.white);
  double lineHeight = 40;

  ParagraphComponent(this.text, this.missingWords);

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final words = text.split(' ');
    double xPos = 20;
    double yPos = 0;
    double screenWidth = size.x;

    blankPositions.clear();

    for (int i = 0; i < words.length; i++) {
      String displayText;
      if (missingWords.contains(words[i])) {
        if (placedWords.containsKey(i)) {
          displayText = placedWords[i]!;
        } else {
          displayText = "___";
        }
      } else {
        displayText = words[i];
      }

      final textSpan = TextSpan(text: displayText, style: style);
      final textPainter =
          TextPainter(text: textSpan, textDirection: TextDirection.ltr);
      textPainter.layout();

      double wordWidth = textPainter.width + 20;

      if (xPos + wordWidth > screenWidth) {
        xPos = 20;
        yPos += lineHeight;
      }

      // Paint the word
      canvas.save();
      canvas.translate(xPos, yPos);
      textPainter.paint(canvas, Offset.zero);
      canvas.restore();

      // Store blank position
      if (missingWords.contains(words[i]) && !placedWords.containsKey(i)) {
        blankPositions.add(Vector2(xPos, yPos));
      }

      xPos += wordWidth;
    }
  }

  Vector2? placeWordAtPosition(String word, Vector2 wordPos) {
    final wordsList = text.split(' ');

    for (int i = 0, blankIndex = 0; i < wordsList.length; i++) {
      if (missingWords.contains(wordsList[i]) && !placedWords.containsKey(i)) {
        final blankPos = blankPositions[blankIndex];

        final distance = (blankPos - wordPos).length;
        print("💬 Checking '$word' → distance: $distance");

        if (distance < 40) {
          placedWords[i] = word;
          print(" Snapped '$word' into index $i at $blankPos");
          return blankPos;
        }

        blankIndex++;
      }
    }

    return null;
  }

  bool checkCompletion() {
    return placedWords.length == missingWords.length &&
        placedWords.values.toSet().containsAll(missingWords);
  }
}
