import 'package:flutter/material.dart';
import '../config/app_theme.dart';
import '../utils/date_utils.dart';

class YearCalendarView extends StatelessWidget {
  final int currentYear;
  final DateTime? selectedDay;
  final ValueChanged<DateTime>? onMonthSelected;

  const YearCalendarView({
    super.key,
    required this.currentYear,
    this.selectedDay,
    this.onMonthSelected,
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
      ),
    );
  }
}

class _MonthCell extends StatelessWidget {
  final int month;
  final int year;
  final DateTime? selectedDay;
  final VoidCallback onTap;

  const _MonthCell({
    required this.month,
    required this.year,
    required this.selectedDay,
    required this.onTap,
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
    if (_isTodayAndSelected) return AppColors.lightRedAccent;
    if (_isSelectedMonth) return AppColors.selectedBlue;
    if (_isCurrentMonth) return AppColors.lightRed;
    return AppColors.white;
  }

  Color get _borderColor {
    if (_isTodayAndSelected || _isSelectedMonth) return AppColors.selectedBlue;
    if (_isCurrentMonth) return AppColors.todayRed;
    return AppColors.lightBorderGrey;
  }

  double get _borderWidth {
    return (_isTodayAndSelected || _isSelectedMonth || _isCurrentMonth) ? 2 : 1;
  }

  Color get _textColor {
    if (_isTodayAndSelected) return AppColors.selectedBlue;
    if (_isSelectedMonth) return AppColors.white;
    if (_isCurrentMonth) return AppColors.darkRed;
    return AppColors.black87;
  }

  FontWeight get _fontWeight {
    return (_isSelectedMonth || _isCurrentMonth)
        ? FontWeight.bold
        : FontWeight.w500;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: _backgroundColor,
          border: Border.all(color: _borderColor, width: _borderWidth),
          borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
        ),
        child: Center(
          child: Text(
            AppDateUtils.getMonthName(month),
            style: TextStyle(
              fontSize: AppDimensions.bodyFontSize,
              fontWeight: _fontWeight,
              color: _textColor,
            ),
          ),
        ),
      ),
    );
  }
}