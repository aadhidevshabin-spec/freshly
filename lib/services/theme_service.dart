import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeService {
  static const String _themeKey = 'app_theme';
  static ThemeService? _instance;
  static ThemeService get instance => _instance ??= ThemeService._();

  ThemeService._();

  bool _isDarkMode = false;
  bool get isDarkMode => _isDarkMode;
  
  final _listeners = <VoidCallback>[];
  
  void addListener(VoidCallback listener) {
    _listeners.add(listener);
  }
  
  void removeListener(VoidCallback listener) {
    _listeners.remove(listener);
  }
  
  void _notifyListeners() {
    for (final listener in _listeners) {
      listener();
    }
  }
  
  Future<void> setDarkMode(bool value) async {
    if (_isDarkMode == value) return;
    _isDarkMode = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeKey, value);
    _notifyListeners();
  }
  
  Future<void> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool(_themeKey) ?? false;
    _notifyListeners();
  }

  // Purple gradient colors
  static const Color purplePrimary = Color(0xFF8B5CF6);
  static const Color purpleSecondary = Color(0xFF7C3AED);
  static const Color purpleDark = Color(0xFF6D28D9);
  static const Color purpleDarker = Color(0xFF5B21B6);
  static const Color purpleDarkest = Color(0xFF4C1D95);

  // Light theme colors
  static const Color lightPrimary = purplePrimary;
  static const Color lightBackground = Colors.white;
  static const Color lightSurface = Color(0xFFF8FAFC);
  static const Color lightCardBackground = Colors.white;
  static const Color lightTextPrimary = Color(0xFF1F2937);
  static const Color lightTextSecondary = Color(0xFF6B7280);

  // Dark theme colors
  static const Color darkPrimary = purplePrimary;
  static const Color darkBackground = Color(0xFF0F0F0F);
  static const Color darkSurface = Color(0xFF1A1A1A);
  static const Color darkCardBackground = Color(0xFF2A2A2A);
  static const Color darkTextPrimary = Colors.white;
  static const Color darkTextSecondary = Color(0xFFD1D5DB);

  // Gradient colors for both themes
  static const List<Color> lightGradient = [
    Colors.white,           // Pure white
    Color(0xFFF8FAFC),      // Very light gray
    Color(0xFFE5E7EB),      // Light gray
    Color(0xFFD1D5DB),      // Medium gray
    Color(0xFF9CA3AF),      // Darker gray
    purplePrimary,          // Purple
    purpleSecondary,        // Darker purple
    purpleDark,             // Even darker purple
  ];

  static const List<Color> darkGradient = [
    purpleDarkest,          // Darkest purple
    purpleDarker,           // Darker purple
    purpleDark,             // Dark purple
    purpleSecondary,        // Medium purple
    purplePrimary,          // Primary purple
    Color(0xFF374151),      // Dark gray
    Color(0xFF1F2937),      // Darker gray
    Color(0xFF111827),      // Very dark gray
    Color(0xFF000000),      // Pure black
  ];

  List<Color> get gradientColors => _isDarkMode ? darkGradient : lightGradient;

  ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      primarySwatch: Colors.purple,
      primaryColor: lightPrimary,
      scaffoldBackgroundColor: lightBackground,
      colorScheme: const ColorScheme.light(
        primary: lightPrimary,
        secondary: lightPrimary,
        surface: lightSurface,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: lightTextPrimary,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: lightTextPrimary,
        elevation: 0,
        centerTitle: true,
      ),
      cardTheme: const CardThemeData(
        color: lightCardBackground,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: lightPrimary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          color: lightTextPrimary,
          fontWeight: FontWeight.w700,
        ),
        headlineMedium: TextStyle(
          color: lightTextPrimary,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: TextStyle(
          color: lightTextPrimary,
          fontWeight: FontWeight.w500,
        ),
        bodyMedium: TextStyle(
          color: lightTextSecondary,
          fontWeight: FontWeight.w400,
        ),
      ),
      fontFamily: 'Inter',
      useMaterial3: true,
    );
  }

  ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primarySwatch: Colors.purple,
      primaryColor: darkPrimary,
      scaffoldBackgroundColor: darkBackground,
      colorScheme: const ColorScheme.dark(
        primary: darkPrimary,
        secondary: darkPrimary,
        surface: darkSurface,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: darkTextPrimary,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: darkTextPrimary,
        elevation: 0,
        centerTitle: true,
      ),
      cardTheme: const CardThemeData(
        color: darkCardBackground,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: darkPrimary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          color: darkTextPrimary,
          fontWeight: FontWeight.w700,
        ),
        headlineMedium: TextStyle(
          color: darkTextPrimary,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: TextStyle(
          color: darkTextPrimary,
          fontWeight: FontWeight.w500,
        ),
        bodyMedium: TextStyle(
          color: darkTextSecondary,
          fontWeight: FontWeight.w400,
        ),
      ),
      fontFamily: 'Inter',
      useMaterial3: true,
    );
  }

  Color get backgroundColor => _isDarkMode ? darkBackground : lightBackground;
  Color get surfaceColor => _isDarkMode ? darkSurface : lightSurface;
  Color get cardBackgroundColor => _isDarkMode ? darkCardBackground : lightCardBackground;
  Color get textPrimaryColor => _isDarkMode ? darkTextPrimary : lightTextPrimary;
  Color get textSecondaryColor => _isDarkMode ? darkTextSecondary : lightTextSecondary;



  Future<void> setTheme(bool isDark) async {
    _isDarkMode = isDark;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeKey, isDark);
  }

  Future<void> toggleTheme() async {
    await setTheme(!_isDarkMode);
  }
}