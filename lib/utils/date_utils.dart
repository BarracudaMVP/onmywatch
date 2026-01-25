class AppDateUtils {
  static const List<String> _months = [
    'Январь', 'Февраль', 'Март', 'Апрель',
    'Май', 'Июнь', 'Июль', 'Август',
    'Сентябрь', 'Октябрь', 'Ноябрь', 'Декабрь'
  ];

  static String getMonthName(int month) {
    assert(month >= 1 && month <= 12, 'Месяц должен быть от 1 до 12');
    return _months[month - 1];
  }

  static bool isSelectedInCurrentMonth(DateTime? selectedDay, DateTime today) {
    return selectedDay != null &&
        selectedDay.year == today.year &&
        selectedDay.month == today.month;
  }
  
  static bool isSameMonth(DateTime date1, DateTime date2) {
    return date1.year == date2.year && date1.month == date2.month;
  }
}