import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/welcome_screen.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/home_screen.dart';
import 'screens/waiting_verification_screen.dart';
import 'services/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase

  bool isDarkMode = await getThemePreference(); // Load theme preference

  runApp(MyApp(isDarkMode: isDarkMode)); // Pass theme preference to MyApp
}

// Save Dark Mode Preference
Future<void> saveThemePreference(bool isDarkMode) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool('isDarkMode', isDarkMode);
}

// Load Dark Mode Preference
Future<bool> getThemePreference() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool('isDarkMode') ?? false; // Default: Light mode
}

// Theme Provider (Manages Dark/Light Mode)
class ThemeProvider extends ChangeNotifier {
  bool isDarkMode; // Dark Mode enabled/disabled

  ThemeProvider(this.isDarkMode);

  void toggleTheme() {
    isDarkMode = !isDarkMode;
    saveThemePreference(isDarkMode);
    notifyListeners();
  }
}

// Updated MyApp with Theme Provider
class MyApp extends StatelessWidget {
  final bool isDarkMode;

  const MyApp({super.key, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (context) => AuthService()), // Authentication Provider
        ChangeNotifierProvider(
            create: (context) => ThemeProvider(isDarkMode)), // Theme Provider
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter App',
            theme:
                themeProvider.isDarkMode ? ThemeData.dark() : ThemeData.light(),
            initialRoute: '/welcome',
            routes: {
              '/welcome': (context) => const WelcomeScreen(),
              '/login': (context) => LoginScreen(),
              '/signup': (context) => const SignupScreen(),
              "/waiting_verification": (context) => WaitingVerificationScreen(),
              '/home': (context) => const HomeScreen(),
            },
          );
        },
      ),
    );
  }
}
