import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/background_provider.dart';

Widget buildGradientButton(
  BuildContext context,
  String text,
  Color fallbackColor,
  VoidCallback onTap,
) {
  final bgProvider = Provider.of<BackgroundProvider>(context, listen: false);
  final backgroundImage = bgProvider.background;

  return ElevatedButton(
    onPressed: onTap,
    style: ElevatedButton.styleFrom(
      padding:
          const EdgeInsets.symmetric(horizontal: 24, vertical: 10), // smaller
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      backgroundColor: backgroundImage == null ? fallbackColor : null,
    ).copyWith(
      backgroundColor: backgroundImage != null
          ? MaterialStateProperty.all(Colors.transparent)
          : null,
      shadowColor: MaterialStateProperty.all(Colors.black),
      elevation: MaterialStateProperty.all(0),
    ),
    child: Ink(
      decoration: backgroundImage != null
          ? BoxDecoration(
              gradient: const LinearGradient(
                colors: [Colors.deepPurple, Colors.purpleAccent],
              ),
              borderRadius: BorderRadius.circular(30),
            )
          : null,
      child: Container(
        alignment: Alignment.center,
        constraints:
            const BoxConstraints(minWidth: 100, minHeight: 36), // reduced
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    ),
  );
}
