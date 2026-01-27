import 'package:flutter/material.dart';
import '../widgets/mode_toggle.dart';
import '../widgets/back_to_today_button.dart';
import '../widgets/month_calendar_view.dart';
import '../widgets/year_calendar_view.dart';
import '../widgets/days_counter_header.dart';
import '../widgets/calendar_navigation_header.dart';
import '../config/app_theme.dart';
import '../models/app_settings.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  final AppSettings settings;
  final ValueChanged<AppSettings> onSettingsChanged;

  const HomeScreen({
    super.key,
    required this.settings,
    required this.onSettingsChanged,
  });
  
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late DateTime _focusedDay;
  DateTime? _selectedDay;
  bool _showYearView = false;

  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now();
  }

  AppColors get _colors => AppColors(widget.settings);

  DateTime get _today => DateTime.now();

  bool get _isFocusedInCurrentMonth {
    final today = DateTime.now();
    return _focusedDay.year == today.year && _focusedDay.month == today.month;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                DaysCounterHeader(
                  colors: _colors,
                  settings: widget.settings,
                ),
                Positioned(
                  top: 40,
                  right: 16,
                  child: IconButton(
                    icon: const Icon(Icons.settings, color: Colors.white),
                    onPressed: _openSettings,
                    iconSize: 28,
                  ),
                ),
              ],
            ),
          ),
          Expanded(child: _buildCalendarSection()),
        ],
      ),
    );
  }

  Widget _buildCalendarSection() {
    return Container(
      width: double.infinity,
      color: _colors.secondaryColor,
      padding: const EdgeInsets.fromLTRB(
        AppDimensions.paddingMedium,
        AppDimensions.paddingSmall,
        AppDimensions.paddingMedium,
        AppDimensions.paddingMedium,
      ),
      child: Column(
        children: [
          _buildControlsRow(),
          const SizedBox(height: 12),
          CalendarNavigationHeader(
            showYearView: _showYearView,
            focusedDay: _focusedDay,
            onPreviousPeriod: () => _changePeriod(-1),
            onNextPeriod: () => _changePeriod(1),
          ),
          const SizedBox(height: AppDimensions.paddingSmall),
          Expanded(child: _buildCalendarView()),
        ],
      ),
    );
  }

  Widget _buildControlsRow() {
    return SizedBox(
      height: 48,
      child: Stack(
        children: [
          Center(
            child: ModeToggle(
              isYear: _showYearView,
              onChanged: (isYear) => setState(() => _showYearView = isYear),
              colors: _colors,
            ),
          ),
          if (!_isFocusedInCurrentMonth)
            Align(
              alignment: Alignment.centerRight,
              child: BackToTodayButton(onTap: _resetToToday),
            ),
        ],
      ),
    );
  }

  Widget _buildCalendarView() {
    return AnimatedSwitcher(
      duration: AppConstants.animationDuration,
      switchInCurve: Curves.easeInOut,
      switchOutCurve: Curves.easeInOut,
      transitionBuilder: _calendarTransitionBuilder,
      child: _showYearView ? _buildYearView() : _buildMonthView(),
    );
  }

  Widget _calendarTransitionBuilder(Widget child, Animation<double> animation) {
    return FadeTransition(
      opacity: animation,
      child: ScaleTransition(
        scale: Tween<double>(begin: 0.95, end: 1.0).animate(
          CurvedAnimation(parent: animation, curve: Curves.easeInOutBack),
        ),
        child: child,
      ),
    );
  }

  Widget _buildYearView() {
    return YearCalendarView(
      key: ValueKey('year_${_focusedDay.year}'),
      currentYear: _focusedDay.year,
      selectedDay: _selectedDay,
      onMonthSelected: _handleMonthSelection,
      colors: _colors,
      settings: widget.settings,
    );
  }

  Widget _buildMonthView() {
    return MonthCalendarView(
      key: ValueKey('month_${_focusedDay.year}_${_focusedDay.month}'),
      focusedDay: _focusedDay,
      selectedDay: _selectedDay,
      onDaySelected: _handleDaySelection,
      onPageChanged: _handlePageChange,
      colors: _colors,
      settings: widget.settings,
    );
  }

  void _openSettings() async {
    final newSettings = await Navigator.push<AppSettings>(
      context,
      MaterialPageRoute(
        builder: (context) => SettingsScreen(settings: widget.settings),
      ),
    );

    if (newSettings != null) {
      widget.onSettingsChanged(newSettings);
    }
  }

  void _handleMonthSelection(DateTime date) {
    setState(() {
      _selectedDay = DateTime(date.year, date.month, 1);
      _showYearView = false;
      _focusedDay = date;
    });
  }

  void _handleDaySelection(DateTime day, DateTime focused) {
    setState(() {
      _selectedDay = day;
      _focusedDay = focused;
    });
  }

  void _handlePageChange(DateTime date) {
    setState(() {
      _focusedDay = date;
      _selectedDay = DateTime(date.year, date.month, 1);
    });
  }

  void _resetToToday() {
    setState(() {
      _selectedDay = _today;
      _focusedDay = _today;
      _showYearView = false;
    });
  }

  void _changePeriod(int delta) {
    setState(() {
      if (_showYearView) {
        _focusedDay = DateTime(_focusedDay.year + delta);
      } else {
        _focusedDay = DateTime(_focusedDay.year, _focusedDay.month + delta);
        _selectedDay = DateTime(_focusedDay.year, _focusedDay.month, 1);
      }
    });
  }
}