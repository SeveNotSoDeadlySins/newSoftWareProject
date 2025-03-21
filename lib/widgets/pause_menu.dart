import 'package:flutter/material.dart';

class PauseMenu extends StatelessWidget {
  final VoidCallback onResume;
  final VoidCallback onHome;

  PauseMenu({required this.onResume, required this.onHome});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: onResume,
              child: Text('Resume'),
            ),
            ElevatedButton(
              onPressed: onHome,
              child: Text('Home'),
            ),
            ElevatedButton(
              onPressed: () {
                // Future settings button
              },
              child: Text('Settings'),
            ),
          ],
        ),
      ),
    );
  }
}
