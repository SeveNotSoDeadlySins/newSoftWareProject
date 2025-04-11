import 'package:shared_preferences/shared_preferences.dart';

class PlayerDataService {
  Future<void> addXP(int amount) async {
    final prefs = await SharedPreferences.getInstance();
    final current = prefs.getInt('xp') ?? 0;
    await prefs.setInt('xp', current + amount);
  }

  Future<void> addCoins(int amount) async {
    final prefs = await SharedPreferences.getInstance();
    final current = prefs.getInt('coins') ?? 0;
    await prefs.setInt('coins', current + amount);
  }

  Future<int> getCoins() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('coins') ?? 0;
  }

  Future<int> getXP() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('xp') ?? 0;
  }
}
