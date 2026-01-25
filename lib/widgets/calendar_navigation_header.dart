import 'package:flutter/material.dart';
import '../config/app_theme.dart';
import '../utils/date_utils.dart';

class CalendarNavigationHeader extends StatelessWidget {
  final bool showYearView;
  final DateTime focusedDay;
  final VoidCallback onPreviousPeriod;
  final VoidCallback onNextPeriod;

  const CalendarNavigationHeader({
    super.key,
    required this.showYearView,
    required this.focusedDay,
    required this.onPreviousPeriod,
    required this.onNextPeriod,
  });

  String get _displayText {
    if (showYearView) {
      return '${focusedDay.year}';
    }
    return '${AppDateUtils.getMonthName(focusedDay.month)} ${focusedDay.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: onPreviousPeriod,
          color: AppColors.black87,
        ),
        Text(
          _displayText,
          style: TextStyle(
            fontSize: AppDimensions.subtitleFontSize,
            fontWeight: FontWeight.bold,
            color: AppColors.black87,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.chevron_right),
          onPressed: onNextPeriod,
          color: AppColors.black87,
        ),
      ],
    );
  }
}