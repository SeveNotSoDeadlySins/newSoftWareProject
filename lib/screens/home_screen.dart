import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../main.dart'; // Need this for the theme

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Screen"),
        actions: [
          Switch(
            value: themeProvider.isDarkMode,
            onChanged: (value) {
              themeProvider.toggleTheme();
            },
          ),
        ],
      ),
      body: Center(
        child: Text(
            "Dark Mode is ${themeProvider.isDarkMode ? "Enabled" : "Disabled"}"),
      ),
    );
  }
}
