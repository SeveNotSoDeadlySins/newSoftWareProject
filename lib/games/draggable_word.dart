import 'package:flame/components.dart';
import 'package:flame/events.dart';

class DraggableWord extends PositionComponent with DragCallbacks {
  final String word;
  bool placed = false;

  // For demonstration, we add a target position property.
  // In a real game, you'd likely have more complex logic to determine
  // where this word should be dropped.
  Vector2? targetPosition;

  DraggableWord(this.word, Vector2 position) {
    this.position = position;
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    if (!placed) {
      position.add(event.localDelta);
    }
  }

  @override
  void onDragEnd(DragEndEvent event) {
    // Example collision detection:
    if (targetPosition != null) {
      final distance = (position - targetPosition!).length;
      if (distance < 20) {
        // Snap the word to the target position
        position = targetPosition!.clone();
        markPlaced();
        print("$word placed correctly at $position");
        // Optionally, notify your ParagraphComponent that this word is placed.
      } else {
        // Optionally, reset to original position or do nothing
        print("$word dropped but not in the correct area.");
      }
    } else {
      print("$word drag ended at $position, but no target defined.");
    }
  }

  void markPlaced() {
    placed = true;
  }
}
