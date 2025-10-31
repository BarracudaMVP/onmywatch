import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class MonthCalendarView extends StatelessWidget {
  final DateTime focusedDay;
  final DateTime? selectedDay;
  final void Function(DateTime, DateTime)? onDaySelected;
  final ValueChanged<DateTime> onPageChanged;

  const MonthCalendarView({
    super.key,
    required this.focusedDay,
    this.selectedDay,
    this.onDaySelected,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();

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
      rowHeight: 46,
      availableGestures: AvailableGestures.horizontalSwipe,
      onPageChanged: onPageChanged,
      calendarStyle: CalendarStyle(
        todayDecoration: BoxDecoration(color: Colors.red.shade600, shape: BoxShape.circle),
        todayTextStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        selectedDecoration: BoxDecoration(color: Colors.blue.shade700, shape: BoxShape.circle),
        selectedTextStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        defaultTextStyle: const TextStyle(color: Colors.black87),
        weekendTextStyle: const TextStyle(color: Colors.black87),
        outsideTextStyle: TextStyle(color: Colors.grey.shade400),
      ),
      daysOfWeekStyle: const DaysOfWeekStyle(
        weekdayStyle: TextStyle(fontWeight: FontWeight.w600, color: Colors.black87),
        weekendStyle: TextStyle(fontWeight: FontWeight.w600, color: Colors.black87),
      ),
      calendarBuilders: CalendarBuilders(
        selectedBuilder: (context, day, focusedDay) {
          if (isSameDay(day, today)) {
            return Center(
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.red.shade600,
                  border: Border.all(color: Colors.blue.shade700, width: 3),
                ),
                child: Center(
                  child: Text(
                    '${day.day}',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            );
          }
          return null;
        },
        outsideBuilder: (c, day, _) => Center(
          child: Text('${day.day}', style: TextStyle(color: Colors.grey.shade400)),
        ),
      ),
    );
  }
}