// import 'package:flame/components.dart';
// import 'package:flame/events.dart';

// class DraggableWord extends PositionComponent with DragCallbacks {
//   final String word;
//   final Vector2 correctPosition;
//   bool isDragging = false;

//   DraggableWord(this.word, Vector2 startPosition, this.correctPosition)
//       : super(position: startPosition, size: Vector2(100, 40));

//   @override
//   void onDragStart(DragStartEvent event) {
//     isDragging = true;
//     print("Started dragging $word");
//   }

//   @override
//   void onDragUpdate(DragUpdateEvent event) {
//     if (isDragging) {
//       position.add(event.localDelta); // ✅ FIXED (Use `localDelta`)
//       print("Dragging $word: ${event.localDelta}");
//     }
//   }

//   @override
//   void onDragEnd(DragEndEvent event) {
//     isDragging = false;
//     final distance = (position - correctPosition).length;
//     if (distance < 30) {
//       position = correctPosition;
//       print("Word '$word' placed correctly!");
//     } else {
//       position = Vector2(50, 400); // Reset if incorrect
//       print("Try again!");
//     }
//   }
// }
