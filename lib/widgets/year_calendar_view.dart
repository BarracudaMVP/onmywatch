import 'package:flutter/material.dart';

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

  String _getMonthName(int m) {
    const months = [
      'Январь', 'Февраль', 'Март', 'Апрель', 'Май', 'Июнь',
      'Июль', 'Август', 'Сентябрь', 'Октябрь', 'Ноябрь', 'Декабрь'
    ];
    return months[m - 1];
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final isCurrentYear = currentYear == now.year;
    final currentMonth = now.month;

    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1.8,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: 12,
      itemBuilder: (_, i) {
        final m = i + 1;
        final isCurrentMonth = isCurrentYear && m == currentMonth;
        final isSelectedMonth = selectedDay != null && selectedDay!.year == currentYear && selectedDay!.month == m;
        final isTodayAndSelected = isCurrentMonth && isSelectedMonth;

        return GestureDetector(
          onTap: () => onMonthSelected?.call(DateTime(currentYear, m)),
          child: Container(
            decoration: BoxDecoration(
              color: isTodayAndSelected
                  ? Colors.red.shade100
                  : isSelectedMonth
                      ? Colors.blue.shade700
                      : isCurrentMonth
                          ? Colors.red.shade50
                          : Colors.white,
              border: Border.all(
                color: isTodayAndSelected
                    ? Colors.blue.shade700
                    : isSelectedMonth
                        ? Colors.blue.shade700
                        : isCurrentMonth
                            ? Colors.red.shade600
                            : Colors.grey.shade300,
                width: isTodayAndSelected || isSelectedMonth ? 2 : (isCurrentMonth ? 2 : 1),
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                _getMonthName(m),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: (isSelectedMonth || isCurrentMonth) ? FontWeight.bold : FontWeight.w500,
                  color: isTodayAndSelected
                      ? Colors.blue.shade700
                      : isSelectedMonth
                          ? Colors.white
                          : isCurrentMonth
                              ? Colors.red.shade700
                              : Colors.black87,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}