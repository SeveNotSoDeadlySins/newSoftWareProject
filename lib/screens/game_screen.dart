// import 'package:flutter/material.dart';
// import 'package:flame/game.dart';
// import 'package:new_project/games/sentence_game.dart';
// import 'package:new_project/services/sentence_service.dart';

// class GameScreen extends StatefulWidget {
//   const GameScreen({Key? key}) : super(key: key);

//   @override
//   State<GameScreen> createState() => _GameScreenState();
// }

// class _GameScreenState extends State<GameScreen> {
//   bool isLoading = true;
//   Map<String, dynamic>? sentenceData;

//   @override
//   void initState() {
//     super.initState();
//     _loadData();
//   }

//   Future<void> _loadData() async {
//     final fetched = await SentenceService().fetchRandomSentence();
//     setState(() {
//       sentenceData = fetched;
//       isLoading = false;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (isLoading) {
//       return const Scaffold(
//         body: Center(child: CircularProgressIndicator()),
//       );
//     }

//     if (sentenceData == null) {
//       return Scaffold(
//         body: const Center(child: Text("No data found")),
//       );
//     }

//     final words = sentenceData!['correctPositions'] as List<dynamic>;
//     final wordsData = words.cast<Map<String, dynamic>>();

//     return Scaffold(
//       appBar: AppBar(title: const Text("Sentence Drag Game")),
//       body: GameWidget(
//         game: SentenceGame(wordsData),
//       ),
//     );
//   }
// }
