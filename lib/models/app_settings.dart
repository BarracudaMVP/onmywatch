import 'package:flutter/material.dart';

class AppSettings {
  final Color primaryColor;
  final Color secondaryColor;

  const AppSettings({
    required this.primaryColor,
    required this.secondaryColor,
  });

  // Настройки по умолчанию
  factory AppSettings.defaults() {
    return AppSettings(
      primaryColor: Colors.blue.shade600,
      secondaryColor: Colors.white,
    );
  }

  // Создание из JSON
  factory AppSettings.fromJson(Map<String, dynamic> json) {
    return AppSettings(
      primaryColor: Color(json['primaryColor'] ?? 0xFF1E88E5),
      secondaryColor: Color(json['secondaryColor'] ?? 0xFFFFFFFF),
    );
  }

  // Преобразование в JSON
  Map<String, dynamic> toJson() {
    return {
      'primaryColor': primaryColor.value,
      'secondaryColor': secondaryColor.value,
    };
  }

  // Метод копирования с изменениями
  AppSettings copyWith({
    Color? primaryColor,
    Color? secondaryColor,
  }) {
    return AppSettings(
      primaryColor: primaryColor ?? this.primaryColor,
      secondaryColor: secondaryColor ?? this.secondaryColor,
    );
  }
}