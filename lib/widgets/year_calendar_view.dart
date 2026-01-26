import 'package:flutter/material.dart';
import '../config/app_theme.dart';
import '../models/app_settings.dart';
import '../utils/date_utils.dart' as app_date_utils;

class YearCalendarView extends StatelessWidget {
  final int currentYear;
  final DateTime? selectedDay;
  final ValueChanged<DateTime>? onMonthSelected;
  final AppColors colors;
  final AppSettings settings;

  const YearCalendarView({
    super.key,
    required this.currentYear,
    this.selectedDay,
    this.onMonthSelected,
    required this.colors,
    required this.settings,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(AppDimensions.paddingSmall),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: AppDimensions.gridCrossAxisCount,
        childAspectRatio: AppDimensions.gridAspectRatio,
        crossAxisSpacing: AppDimensions.gridSpacing,
        mainAxisSpacing: AppDimensions.gridSpacing,
      ),
      itemCount: 12,
      itemBuilder: (context, index) => _MonthCell(
        month: index + 1,
        year: currentYear,
        selectedDay: selectedDay,
        onTap: () => onMonthSelected?.call(DateTime(currentYear, index + 1)),
        colors: colors,
        settings: settings,
      ),
    );
  }
}

class _MonthCell extends StatelessWidget {
  final int month;
  final int year;
  final DateTime? selectedDay;
  final VoidCallback onTap;
  final AppColors colors;
  final AppSettings settings;

  const _MonthCell({
    required this.month,
    required this.year,
    required this.selectedDay,
    required this.onTap,
    required this.colors,
    required this.settings,
  });

  bool get _isCurrentMonth {
    final now = DateTime.now();
    return year == now.year && month == now.month;
  }

  bool get _isSelectedMonth {
    return selectedDay != null &&
        selectedDay!.year == year &&
        selectedDay!.month == month;
  }

  bool get _isTodayAndSelected => _isCurrentMonth && _isSelectedMonth;

  Color get _backgroundColor {
    if (_isTodayAndSelected) return colors.accentLightAccent;
    if (_isSelectedMonth) return colors.primaryColor;
    if (_isCurrentMonth) return colors.accentLight;
    return colors.secondaryColor;
  }

  Color get _borderColor {
    if (_isTodayAndSelected || _isSelectedMonth) return colors.primaryColor;
    if (_isCurrentMonth) return colors.accentColor;
    return AppColors.lightBorderGrey;
  }

  double get _borderWidth {
    return (_isTodayAndSelected || _isSelectedMonth || _isCurrentMonth) ? 2 : 1;
  }

  Color get _textColor {
    if (_isTodayAndSelected) return colors.primaryColor;
    if (_isSelectedMonth) return AppColors.white;
    if (_isCurrentMonth) return colors.accentDark;
    return AppColors.black87;
  }

  FontWeight get _fontWeight {
    return (_isSelectedMonth || _isCurrentMonth)
        ? FontWeight.bold
        : FontWeight.w500;
  }

  @override
  Widget build(BuildContext context) {
    final workPercentage = app_date_utils.AppDateUtils.getWorkPercentageForMonth(
      year,
      month,
      settings,
    );

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: _backgroundColor,
          border: Border.all(color: _borderColor, width: _borderWidth),
          borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
        ),
        child: workPercentage >= 0
            ? _buildShiftMonthCell(workPercentage)
            : _buildRegularMonthCell(),
      ),
    );
  }

  Widget _buildRegularMonthCell() {
    return Center(
      child: Text(
        app_date_utils.AppDateUtils.getMonthName(month),
        style: TextStyle(
          fontSize: AppDimensions.bodyFontSize,
          fontWeight: _fontWeight,
          color: _textColor,
        ),
      ),
    );
  }

  Widget _buildShiftMonthCell(double workPercentage) {
    return Stack(
      children: [
        // Фоновая закраска рабочих/выходных дней
        Row(
          children: [
            if (workPercentage > 0)
              Expanded(
                flex: (workPercentage * 100).round(),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(AppDimensions.cardRadius - 2),
                      bottomLeft: Radius.circular(AppDimensions.cardRadius - 2),
                      topRight: workPercentage >= 0.99
                          ? Radius.circular(AppDimensions.cardRadius - 2)
                          : Radius.zero,
                      bottomRight: workPercentage >= 0.99
                          ? Radius.circular(AppDimensions.cardRadius - 2)
                          : Radius.zero,
                    ),
                  ),
                ),
              ),
            if (workPercentage < 1.0)
              Expanded(
                flex: ((1 - workPercentage) * 100).round(),
                child: Container(
                  decoration: BoxDecoration(
                    color: colors.accentLight,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(AppDimensions.cardRadius - 2),
                      bottomRight: Radius.circular(AppDimensions.cardRadius - 2),
                      topLeft: workPercentage <= 0.01
                          ? Radius.circular(AppDimensions.cardRadius - 2)
                          : Radius.zero,
                      bottomLeft: workPercentage <= 0.01
                          ? Radius.circular(AppDimensions.cardRadius - 2)
                          : Radius.zero,
                    ),
                  ),
                ),
              ),
          ],
        ),
        // Текст сверху
        Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            decoration: BoxDecoration(
              color: _backgroundColor.withOpacity(0.8),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              app_date_utils.AppDateUtils.getMonthName(month),
              style: TextStyle(
                fontSize: AppDimensions.bodyFontSize,
                fontWeight: _fontWeight,
                color: _textColor,
              ),
            ),
          ),
        ),
      ],
    );
  }
}