import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme => ThemeData(
    primarySwatch: Colors.blue,
    useMaterial3: true,
  );
}

class AppColors {
  // Основные цвета
  static final primaryBlue = Colors.blue.shade600;
  static final selectedBlue = Colors.blue.shade700;
  static final todayRed = Colors.red.shade600;
  static final lightRed = Colors.red.shade50;
  static final lightRedAccent = Colors.red.shade100;
  static final darkRed = Colors.red.shade700;
  
  // Фоновые цвета
  static final backgroundGrey = Colors.grey.shade100;
  static final borderGrey = Colors.grey.shade400;
  static final lightBorderGrey = Colors.grey.shade300;
  
  // Цвета текста
  static final textGrey = Colors.grey.shade700;
  static final lightTextGrey = Colors.grey.shade400;
  static const white = Colors.white;
  static const white70 = Colors.white70;
  static const black87 = Colors.black87;
}

class AppDimensions {
  // Размеры кнопок и элементов
  static const double iconButtonSize = 40.0;
  static const double toggleButtonRadius = 24.0;
  static const double cardRadius = 12.0;
  
  // Размеры календаря
  static const double calendarRowHeight = 46.0;
  static const double calendarCellSize = 36.0;
  
  // Grid параметры
  static const int gridCrossAxisCount = 3;
  static const double gridAspectRatio = 1.8;
  static const double gridSpacing = 12.0;
  
  // Отступы
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  
  // Размеры текста
  static const double headerFontSize = 96.0;
  static const double titleFontSize = 24.0;
  static const double subtitleFontSize = 18.0;
  static const double bodyFontSize = 16.0;
  
  // Иконки
  static const double smallIconSize = 20.0;
}

class AppConstants {
  static const Duration animationDuration = Duration(milliseconds: 500);
  static const Duration toggleDuration = Duration(milliseconds: 200);
  
  static const String monthToggleLabel = 'М';
  static const String yearToggleLabel = 'Г';
  
  static const String daysLeftLabel = 'Осталось дней';
}