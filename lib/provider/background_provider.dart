import 'package:flutter/material.dart';

class BackgroundProvider with ChangeNotifier {
  String? _background;

  /// Get the currently equipped background (e.g. 'galaxy.png')
  String? get background => _background;

  /// Set the background image filename
  void setBackground(String? bg) {
    _background = bg;
    notifyListeners();
  }

  /// Clear background (for unequip)
  void clearBackground() {
    _background = null;
    notifyListeners();
  }

  /// Get the appropriate text color based on the current background
  Color get textColor {
    switch (_background) {
      case 'galaxy.png':
      case 'space.png':
      case 'neon.png':
        return Colors.white;
      case 'sunset.png':
      case 'clouds.png':
        return Colors.black;
      default:
        return Colors.black;
    }
  }
}
