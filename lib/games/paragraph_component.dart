import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class ParagraphComponent extends PositionComponent {
  final String text;
  final List<String> missingWords;
  final Map<int, String> placedWords = {};

  // Style for your paragraph text
  final TextStyle style = const TextStyle(fontSize: 24, color: Colors.white);

  double lineHeight = 30; // Space between lines

  ParagraphComponent(this.text, this.missingWords);

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final words = text.split(' ');
    double xPos = 20;
    double yPos = 50;
    double screenWidth = size.x; // The width of your game screen

    for (int i = 0; i < words.length; i++) {
      // If word is missing, show "___" or a placed word
      String displayText = missingWords.contains(words[i])
          ? (placedWords[i] ?? "___")
          : words[i];

      // 1. Create a TextPainter for each word
      final textSpan = TextSpan(text: displayText, style: style);
      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      );
      textPainter.layout(); // Layout the text to get its dimensions

      // 2. Measure the word's width
      double wordWidth = textPainter.width + 20; // +20 for spacing

      // 3. Wrap to a new line if it exceeds the screen width
      if (xPos + wordWidth > screenWidth) {
        xPos = 20;
        yPos += lineHeight;
      }

      // 4. Paint the text onto the Canvas
      canvas.save();
      canvas.translate(xPos, yPos);
      textPainter.paint(canvas, Offset.zero);
      canvas.restore();

      // 5. Advance x-position for the next word
      xPos += wordWidth;
    }
  }

  void placeWord(int index, String word) {
    placedWords[index] = word;
  }

  bool checkCompletion() {
    return placedWords.length == missingWords.length &&
        placedWords.values.toSet().containsAll(missingWords);
  }
}
