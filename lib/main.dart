import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/welcome_screen.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/home_screen.dart';
import 'screens/waiting_verification_screen.dart';
import 'services/auth_service.dart';
import 'package:provider/provider.dart';
import 'provider/background_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  bool isDarkMode = await getThemePreference();

  runApp(MyApp(isDarkMode: isDarkMode));
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
        ChangeNotifierProvider(
            create: (_) => BackgroundProvider()), // Background Provider
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter App',
            theme: ThemeData(
              useMaterial3: true,
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  elevation: 6, // adds drop shadow
                  backgroundColor:
                      const Color(0xFF6A5ACD), // fallback base color
                  foregroundColor: Colors.white,
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.5,
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                    side: const BorderSide(color: Colors.black, width: 1.5),
                  ),
                ).copyWith(
                  backgroundColor:
                      MaterialStateProperty.resolveWith<Color>((states) {
                    return Colors
                        .transparent; // will be overridden with gradient
                  }),
                  shadowColor: MaterialStateProperty.all(Colors.black),
                ),
              ),
            ),
            initialRoute: '/welcome',
            routes: {
              '/welcome': (context) => const WelcomeScreen(),
              '/login': (context) => LoginScreen(),
              '/signup': (context) => const SignupScreen(),
              "/waiting_verification": (context) => WaitingVerificationScreen(),
              '/home': (context) => HomeScreen(),
            },
          );
        },
      ),
    );
  }
}
