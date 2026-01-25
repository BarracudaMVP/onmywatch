import 'package:flutter/material.dart';

class AppSettings {
  final Color primaryColor;
  final Color accentColor;

  const AppSettings({
    required this.primaryColor,
    required this.accentColor,
  });

  // Настройки по умолчанию
  factory AppSettings.defaults() {
    return AppSettings(
      primaryColor: Colors.blue.shade600,
      accentColor: Colors.red.shade600,
    );
  }

  // Создание из JSON
  factory AppSettings.fromJson(Map<String, dynamic> json) {
    return AppSettings(
      primaryColor: Color(json['primaryColor'] ?? 0xFF1E88E5),
      accentColor: Color(json['accentColor'] ?? 0xFFE53935),
    );
  }

  // Преобразование в JSON
  Map<String, dynamic> toJson() {
    return {
      'primaryColor': primaryColor.value,
      'accentColor': accentColor.value,
    };
  }

  // Метод копирования с изменениями
  AppSettings copyWith({
    Color? primaryColor,
    Color? accentColor,
  }) {
    return AppSettings(
      primaryColor: primaryColor ?? this.primaryColor,
      accentColor: accentColor ?? this.accentColor,
    );
  }
}