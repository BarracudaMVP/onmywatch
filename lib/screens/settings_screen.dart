import 'package:flutter/material.dart';
import '../models/app_settings.dart';
import '../config/app_theme.dart';
import '../widgets/settings/settings_group.dart';
import '../widgets/settings/color_picker_setting.dart';

class SettingsScreen extends StatefulWidget {
  final AppSettings settings;

  const SettingsScreen({super.key, required this.settings});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late AppSettings _currentSettings;

  @override
  void initState() {
    super.initState();
    _currentSettings = widget.settings;
  }

  void _updatePrimaryColor(Color color) {
    setState(() {
      _currentSettings = _currentSettings.copyWith(primaryColor: color);
    });
  }

  void _updateAccentColor(Color color) {
    setState(() {
      _currentSettings = _currentSettings.copyWith(accentColor: color);
    });
  }

  void _resetToDefaults() {
    setState(() {
      _currentSettings = AppSettings.defaults();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Настройки'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, _currentSettings);
            },
            child: const Text(
              'Готово',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ],
      ),
      body: ListView(
        children: [
          SettingsGroup(
            title: 'Визуал и цвета',
            children: [
              ColorPickerSetting(
                title: 'Основной цвет',
                subtitle: 'Цвет интерфейса приложения',
                currentColor: _currentSettings.primaryColor,
                onColorChanged: _updatePrimaryColor,
              ),
              ColorPickerSetting(
                title: 'Дополнительный цвет',
                subtitle: 'Цвет акцентных элементов',
                currentColor: _currentSettings.accentColor,
                onColorChanged: _updateAccentColor,
              ),
            ],
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: OutlinedButton(
              onPressed: _resetToDefaults,
              child: const Text('Сбросить настройки'),
            ),
          ),
        ],
      ),
    );
  }
}