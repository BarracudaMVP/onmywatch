import 'package:flutter/material.dart';
import '../models/app_settings.dart';

class AppTheme {
  static ThemeData lightTheme(AppSettings settings) => ThemeData(
    primarySwatch: _createMaterialColor(settings.primaryColor),
    useMaterial3: true,
  );

  // Вспомогательный метод для создания MaterialColor
  static MaterialColor _createMaterialColor(Color color) {
    List strengths = <double>[.05];
    Map<int, Color> swatch = {};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    for (var strength in strengths) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    }
    return MaterialColor(color.value, swatch);
  }
}

class AppColors {
  final Color primaryColor;
  final Color accentColor;

  AppColors(AppSettings settings)
      : primaryColor = settings.primaryColor,
        accentColor = settings.accentColor;

  // Производные цвета
  Color get primaryLight => Color.lerp(primaryColor, Colors.white, 0.7)!;
  Color get accentLight => Color.lerp(accentColor, Colors.white, 0.85)!;
  Color get accentLightAccent => Color.lerp(accentColor, Colors.white, 0.7)!;
  Color get accentDark => Color.lerp(accentColor, Colors.black, 0.2)!;
  
  // Статические цвета (неизменные)
  static final backgroundGrey = Colors.grey.shade100;
  static final borderGrey = Colors.grey.shade400;
  static final lightBorderGrey = Colors.grey.shade300;
  static final textGrey = Colors.grey.shade700;
  static final lightTextGrey = Colors.grey.shade400;
  static const white = Colors.white;
  static const white70 = Colors.white70;
  static const black87 = Colors.black87;
}

class AppDimensions {
  static const double iconButtonSize = 40.0;
  static const double toggleButtonRadius = 24.0;
  static const double cardRadius = 12.0;
  static const double calendarRowHeight = 46.0;
  static const double calendarCellSize = 36.0;
  static const int gridCrossAxisCount = 3;
  static const double gridAspectRatio = 1.8;
  static const double gridSpacing = 12.0;
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double headerFontSize = 96.0;
  static const double titleFontSize = 24.0;
  static const double subtitleFontSize = 18.0;
  static const double bodyFontSize = 16.0;
  static const double smallIconSize = 20.0;
}

class AppConstants {
  static const Duration animationDuration = Duration(milliseconds: 500);
  static const Duration toggleDuration = Duration(milliseconds: 200);
  static const String monthToggleLabel = 'М';
  static const String yearToggleLabel = 'Г';
  static const String daysLeftLabel = 'Осталось дней';
}