// File: lib/components/draggable_word.dart
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import '../games/paragraph_component.dart';
import '../components/draggable_card.dart';

class DraggableWord extends TextComponent with DragCallbacks {
  final String word;
  final ParagraphComponent paragraph;
  late Vector2 _startPosition;

  DraggableWord(this.word, Vector2 position, this.paragraph)
      : super(
          text: word,
          position: position,
          anchor: Anchor.center,
          priority: 1,
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    _startPosition = position.clone();
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    position += event.localDelta;
  }

  @override
  void onDragEnd(DragEndEvent event) {
    // Here you can implement logic like checking if it overlaps a blank
    position.setFrom(
        _startPosition); // Return to original position if not dropped correctly
  }
}
