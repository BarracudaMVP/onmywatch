import 'package:flutter/material.dart';
import '../models/app_settings.dart';
import '../widgets/settings/settings_group.dart';
import '../widgets/settings/color_picker_setting.dart';
import '../widgets/settings/work_schedule_selector.dart';

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

  void _updateSecondaryColor(Color color) {
    setState(() {
      _currentSettings = _currentSettings.copyWith(secondaryColor: color);
    });
  }

  void _updateSettings(AppSettings settings) {
    setState(() {
      _currentSettings = settings;
    });
  }

  void _resetToDefaults() {
    setState(() {
      _currentSettings = AppSettings.defaults();
    });
  }

  void _saveAndExit() {
    Navigator.pop(context, _currentSettings);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, null);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Настройки'),
          backgroundColor: _currentSettings.primaryColor,
          foregroundColor: Colors.white,
          actions: [
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: _saveAndExit,
              tooltip: 'Сохранить',
            ),
          ],
        ),
        body: Container(
          color: _currentSettings.secondaryColor,
          child: ListView(
            children: [
              SettingsGroup(
                title: 'Визуал и цвета',
                children: [
                  ColorPickerSetting(
                    title: 'Основной цвет',
                    subtitle: 'Цвет верхней панели и элементов интерфейса',
                    currentColor: _currentSettings.primaryColor,
                    onColorChanged: _updatePrimaryColor,
                  ),
                  ColorPickerSetting(
                    title: 'Второстепенный цвет',
                    subtitle: 'Цвет фона нижней половины экрана',
                    currentColor: _currentSettings.secondaryColor,
                    onColorChanged: _updateSecondaryColor,
                  ),
                ],
              ),
              SettingsGroup(
                title: 'Настройки календаря',
                children: [
                  WorkScheduleSelector(
                    settings: _currentSettings,
                    onSettingsChanged: _updateSettings,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: OutlinedButton(
                  onPressed: _resetToDefaults,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: _currentSettings.primaryColor,
                    side: BorderSide(color: _currentSettings.primaryColor),
                  ),
                  child: const Text('Сбросить настройки'),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}