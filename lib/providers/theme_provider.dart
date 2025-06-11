import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  // ✅ Default theme is light
  ThemeMode _themeMode = ThemeMode.light;

  // Getter for current theme mode
  ThemeMode get themeMode => _themeMode;

  // Returns true if the current theme is dark
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  // Constructor: loads saved theme preference when the provider is initialized
  ThemeProvider() {
    _loadTheme(); // Load from SharedPreferences
  }

  /// Toggles the theme between light and dark mode
  /// Also saves the preference in SharedPreferences
  void toggleTheme(bool isDark) async {
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("isDarkMode", isDark); // Persist the choice
    notifyListeners(); // Notify UI to rebuild
  }

  /// Loads the saved theme mode from SharedPreferences
  void _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool("isDarkMode"); // May return null

    if (isDark != null) {
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
      notifyListeners(); // Update UI when theme is loaded
    }
  }
}
