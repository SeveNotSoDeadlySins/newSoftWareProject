import 'package:flutter/material.dart';
import 'package:new_project/screens/shop_screen.dart';
import 'game_screen.dart';
import 'eco_match_screen.dart';
import 'profile_screen.dart';
import 'package:provider/provider.dart';
import '../provider/background_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // Reusable widget to build a game card with image and title
  Widget _buildGameCard(
    BuildContext context, {
    required String image,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap, // Navigate when tapped
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Game image (top half of the card)
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
              child: Image.asset(
                image,
                fit: BoxFit.cover,
                height: 350,
              ),
            ),
            // Title text
            Container(
              padding: const EdgeInsets.all(12),
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BackgroundProvider>(
      builder: (context, bgProvider, child) {
        final backgroundImage = bgProvider.background;

        return Scaffold(
          // 🔹 Custom gradient AppBar
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight),
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF7F00FF), Color(0xFFE100FF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                title: const Text("Eco Explorers",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                centerTitle: true,
                leading: IconButton(
                  icon: const Icon(Icons.store),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const ShopScreen()));
                  },
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.person),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const ProfileScreen()),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),

          // 🔹 Main background: either custom image or gradient fallback
          body: Container(
            decoration: backgroundImage != null
                ? BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/backgrounds/$backgroundImage'),
                      fit: BoxFit.cover,
                    ),
                  )
                : const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF7F00FF), Color(0xFFE100FF)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Game Card 1: Litter Catcher
                  _buildGameCard(
                    context,
                    image: 'assets/images/litter_catcher_preview.png',
                    title: 'Litter Catcher',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const GameScreen(controlMode: 'drag'),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 20),

                  // Game Card 2: Eco Match
                  _buildGameCard(
                    context,
                    image: 'assets/images/eco_match_preview.png',
                    title: 'Eco Match',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const EcoMatchScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
