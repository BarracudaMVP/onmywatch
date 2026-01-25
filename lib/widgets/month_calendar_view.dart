import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../config/app_theme.dart';

class MonthCalendarView extends StatelessWidget {
  final DateTime focusedDay;
  final DateTime? selectedDay;
  final void Function(DateTime, DateTime)? onDaySelected;
  final ValueChanged<DateTime> onPageChanged;
  final AppColors colors;

  const MonthCalendarView({
    super.key,
    required this.focusedDay,
    this.selectedDay,
    this.onDaySelected,
    required this.onPageChanged,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      firstDay: DateTime.utc(2020, 1, 1),
      lastDay: DateTime.utc(2030, 12, 31),
      focusedDay: focusedDay,
      selectedDayPredicate: (day) => isSameDay(selectedDay, day),
      onDaySelected: onDaySelected,
      startingDayOfWeek: StartingDayOfWeek.monday,
      calendarFormat: CalendarFormat.month,
      locale: 'ru_RU',
      headerVisible: false,
      rowHeight: AppDimensions.calendarRowHeight,
      availableGestures: AvailableGestures.horizontalSwipe,
      onPageChanged: onPageChanged,
      calendarStyle: CalendarStyle(
        todayDecoration: BoxDecoration(
          color: colors.accentColor,
          shape: BoxShape.circle,
        ),
        todayTextStyle: TextStyle(
          color: AppColors.white,
          fontWeight: FontWeight.bold,
        ),
        selectedDecoration: BoxDecoration(
          color: colors.primaryColor,
          shape: BoxShape.circle,
        ),
        selectedTextStyle: TextStyle(
          color: AppColors.white,
          fontWeight: FontWeight.bold,
        ),
        defaultTextStyle: TextStyle(color: AppColors.black87),
        weekendTextStyle: TextStyle(color: AppColors.black87),
        outsideTextStyle: TextStyle(color: AppColors.lightTextGrey),
      ),
      daysOfWeekStyle: DaysOfWeekStyle(
        weekdayStyle: TextStyle(
          fontWeight: FontWeight.w600,
          color: AppColors.black87,
        ),
        weekendStyle: TextStyle(
          fontWeight: FontWeight.w600,
          color: AppColors.black87,
        ),
      ),
      calendarBuilders: CalendarBuilders(
        selectedBuilder: (context, day, focusedDay) => _buildSelectedDay(context, day, focusedDay),
        outsideBuilder: (context, day, focusedDay) => _buildOutsideDay(context, day, focusedDay),
      ),
    );
  }

  Widget? _buildSelectedDay(BuildContext context, DateTime day, DateTime focusedDay) {
    final today = DateTime.now();
    if (!isSameDay(day, today)) return null;

    return Center(
      child: Container(
        width: AppDimensions.calendarCellSize,
        height: AppDimensions.calendarCellSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: colors.accentColor,
          border: Border.all(color: colors.primaryColor, width: 3),
        ),
        child: Center(
          child: Text(
            '${day.day}',
            style: TextStyle(
              color: AppColors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOutsideDay(BuildContext context, DateTime day, DateTime focusedDay) {
    return Center(
      child: Text(
        '${day.day}',
        style: TextStyle(color: AppColors.lightTextGrey),
      ),
    );
  }
}