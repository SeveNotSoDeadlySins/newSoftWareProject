import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../main.dart'; // Need this for theme switching
// import 'game_screen.dart'; // Import the Game Screen

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Screen"),
        actions: [
          // Dark Mode Toggle Switch
          Switch(
            value: themeProvider.isDarkMode,
            onChanged: (value) {
              themeProvider.toggleTheme();
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Dark Mode is ${themeProvider.isDarkMode ? "Enabled" : "Disabled"}",
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),

            // Start Game Button
            // ElevatedButton(
            //   onPressed: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(builder: (context) => const GameScreen()),
            //     );
            //   },
            //   child: const Text("Start Game"),
            // ),
          ],
        ),
      ),
    );
  }
}
