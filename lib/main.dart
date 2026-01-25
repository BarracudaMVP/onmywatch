import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'screens/home_screen.dart';
import 'config/app_theme.dart';
import 'models/app_settings.dart';
import 'services/settings_service.dart';

void main() {
  initializeDateFormatting('ru_RU', null).then((_) => runApp(const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final SettingsService _settingsService = SettingsService();
  AppSettings _settings = AppSettings.defaults();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final settings = await _settingsService.loadSettings();
    if (mounted) {
      setState(() {
        _settings = settings;
        _isLoading = false;
      });
    }
  }

  void _updateSettings(AppSettings settings) {
    if (mounted) {
      setState(() {
        _settings = settings;
      });
    }
    _settingsService.saveSettings(settings);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const MaterialApp(
        home: Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    return MaterialApp(
      locale: const Locale('ru', 'RU'),
      supportedLocales: const [
        Locale('ru', 'RU'),
        Locale('en', 'US'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      title: 'On My Watch',
      theme: AppTheme.lightTheme(_settings),
      home: HomeScreen(
        key: ValueKey(_settings), // Добавили key для обновления при изменении настроек
        settings: _settings,
        onSettingsChanged: _updateSettings,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}