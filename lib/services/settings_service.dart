import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/app_settings.dart';

/// Сервис для работы с настройками приложения
///
/// Использует SharedPreferences для локального хранения настроек
class SettingsService {
  static const String _settingsKey = 'app_settings';

  /// Сохраняет настройки приложения в локальное хранилище
  Future<void> saveSettings(AppSettings settings) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = jsonEncode(settings.toJson());
      await prefs.setString(_settingsKey, jsonString);
      debugPrint('✅ Настройки успешно сохранены');
    } catch (e, stackTrace) {
      debugPrint('❌ Ошибка при сохранении настроек: $e');
      debugPrint('Stack trace: $stackTrace');
    }
  }

  /// Загружает настройки приложения из локального хранилища
  ///
  /// Если настройки отсутствуют или произошла ошибка,
  /// возвращает настройки по умолчанию
  Future<AppSettings> loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_settingsKey);

      if (jsonString == null || jsonString.isEmpty) {
        debugPrint('ℹ️ Настройки не найдены, используются значения по умолчанию');
        return AppSettings.defaults();
      }

      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      debugPrint('✅ Настройки успешно загружены');
      return AppSettings.fromJson(json);
    } catch (e, stackTrace) {
      debugPrint('❌ Ошибка при загрузке настроек: $e');
      debugPrint('Stack trace: $stackTrace');
      debugPrint('ℹ️ Используются настройки по умолчанию');
      return AppSettings.defaults();
    }
  }

  /// Сбрасывает все настройки к значениям по умолчанию
  Future<void> resetSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_settingsKey);
      debugPrint('✅ Настройки успешно сброшены');
    } catch (e, stackTrace) {
      debugPrint('❌ Ошибка при сбросе настроек: $e');
      debugPrint('Stack trace: $stackTrace');
    }
  }
}