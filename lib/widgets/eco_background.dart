import 'package:flutter/material.dart';

class EcoBackground extends StatelessWidget {
  final Widget child;

  const EcoBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFFF3E5F5), // Deep Purple
            Color(0xFFE100FF), // Pink-Purple
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: child,
    );
  }
}
