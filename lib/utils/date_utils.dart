import 'package:intl/intl.dart';
import '../models/app_settings.dart';

/// Информация о сегменте закраски месяца
class MonthColorSegment {
  final double start; // 0.0 - 1.0
  final double end; // 0.0 - 1.0
  final bool isWork;

  MonthColorSegment({
    required this.start,
    required this.end,
    required this.isWork,
  });
}

/// Утилиты для работы с датами и расчётами рабочих графиков
class AppDateUtils {
  /// Проверяет, что две даты представляют один и тот же день
  static bool isSameDay(DateTime? a, DateTime? b) {
    if (a == null || b == null) return false;
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  /// Проверяет, находится ли выбранная дата в текущем месяце
  static bool isSelectedInCurrentMonth(DateTime? selected, DateTime today) {
    if (selected == null) return true;
    return selected.year == today.year && selected.month == today.month;
  }

  /// Возвращает название месяца по его номеру (1-12)
  static String getMonthName(int month) {
    const months = [
      'Январь', 'Февраль', 'Март', 'Апрель', 'Май', 'Июнь',
      'Июль', 'Август', 'Сентябрь', 'Октябрь', 'Ноябрь', 'Декабрь'
    ];
    return months[month - 1];
  }

  /// Определяет, является ли день рабочим согласно выбранному графику работы
  ///
  /// Поддерживает 4 типа графиков:
  /// - 5/2: пн-пт работа, сб-вс выходные
  /// - 2/2: настраиваемый цикл работы/отдыха
  /// - Вахта по дням: половина периода работа, половина отдых
  /// - Вахта по месяцам: долгосрочная вахта с месячными периодами
  static bool isWorkingDay(DateTime day, AppSettings settings) {
    switch (settings.workScheduleType) {
      case WorkScheduleType.fiveTwoSchedule:
        final weekday = day.weekday;
        final isWeekend = weekday == DateTime.saturday || weekday == DateTime.sunday;
        return !isWeekend;

      case WorkScheduleType.twoTwoSchedule:
        if (settings.workPeriodStartDate == null) return false;
        final daysSinceStart = day.difference(settings.workPeriodStartDate!).inDays;
        if (daysSinceStart < 0) return false;

        final cycle = settings.workDays + settings.restDays;
        if (cycle <= 0) return false;

        final positionInCycle = daysSinceStart % cycle;
        return positionInCycle < settings.workDays;

      case WorkScheduleType.shiftByDays:
        if (settings.workPeriodStartDate == null) return false;
        final daysSinceStart = day.difference(settings.workPeriodStartDate!).inDays;
        if (daysSinceStart < 0) return false;

        final cycle = settings.workDays + settings.restDays;
        if (cycle <= 0) return false;

        final positionInCycle = daysSinceStart % cycle;
        return positionInCycle < settings.workDays;

      case WorkScheduleType.shiftByMonths:
        if (settings.workPeriodStartDate == null) return false;

        final startDate = settings.workPeriodStartDate!;
        final startDay = startDate.day;

        // Вычисляем количество полных периодов (месяцев), прошедших с начальной даты
        // Период меняется в тот же день каждого месяца
        int monthsPassed = (day.year - startDate.year) * 12 + (day.month - startDate.month);

        // Если еще не дошли до дня смены периода в текущем месяце, уменьшаем счетчик
        if (day.day < startDay) {
          monthsPassed--;
        }

        if (monthsPassed < 0) return false;

        // Вычисляем количество месяцев в одном периоде (30 дней ≈ 1 месяц)
        final monthsInPeriod = (settings.shiftMonthsPeriod / 30).round();
        if (monthsInPeriod <= 0) return false;

        // Определяем позицию в полном цикле (работа + отдых)
        final fullCycle = monthsInPeriod * 2;
        final positionInCycle = monthsPassed % fullCycle;

        return positionInCycle < monthsInPeriod;
    }
  }

  /// Рассчитывает процент рабочих дней в месяце для вахтовых графиков
  ///
  /// Возвращает null для обычных графиков (5/2, 2/2), так как для них
  /// процент рабочих дней не отображается в годовом представлении
  static double? getWorkPercentageForMonth(int year, int month, AppSettings settings) {
    // Для обычных графиков не показываем полосу
    if (settings.workScheduleType == WorkScheduleType.fiveTwoSchedule ||
        settings.workScheduleType == WorkScheduleType.twoTwoSchedule) {
      return null;
    }

    // Подсчитываем реальный процент рабочих дней для вахтовых графиков
    final daysInMonth = DateTime(year, month + 1, 0).day;
    int workingDaysCount = 0;

    for (int day = 1; day <= daysInMonth; day++) {
      final date = DateTime(year, month, day);
      if (isWorkingDay(date, settings)) {
        workingDaysCount++;
      }
    }

    return workingDaysCount / daysInMonth;
  }

  /// Возвращает сегменты закраски месяца для вахтовых графиков
  ///
  /// Каждый сегмент содержит начало и конец (0.0-1.0) и тип (работа/отдых)
  /// Возвращает null для обычных графиков (5/2, 2/2)
  static List<MonthColorSegment>? getMonthWorkSegments(
      int year, int month, AppSettings settings) {
    // Для обычных графиков не показываем сегменты
    if (settings.workScheduleType == WorkScheduleType.fiveTwoSchedule ||
        settings.workScheduleType == WorkScheduleType.twoTwoSchedule) {
      return null;
    }

    final daysInMonth = DateTime(year, month + 1, 0).day;
    final segments = <MonthColorSegment>[];

    // Находим все смены фазы в месяце
    bool? currentPhase;
    int segmentStart = 1;

    for (int day = 1; day <= daysInMonth; day++) {
      final date = DateTime(year, month, day);
      final isWork = isWorkingDay(date, settings);

      if (currentPhase == null) {
        // Первый день месяца
        currentPhase = isWork;
        segmentStart = day;
      } else if (currentPhase != isWork) {
        // Смена фазы
        final segmentEnd = day - 1;
        segments.add(MonthColorSegment(
          start: (segmentStart - 1) / daysInMonth,
          end: segmentEnd / daysInMonth,
          isWork: currentPhase,
        ));

        currentPhase = isWork;
        segmentStart = day;
      }
    }

    // Добавляем последний сегмент
    if (currentPhase != null) {
      segments.add(MonthColorSegment(
        start: (segmentStart - 1) / daysInMonth,
        end: 1.0,
        isWork: currentPhase,
      ));
    }

    return segments.isEmpty ? null : segments;
  }

  /// Рассчитывает количество дней до смены фазы (работа ↔ отдых)
  ///
  /// Для каждого графика работы определяет, сколько дней осталось
  /// до перехода в противоположную фазу (с работы на отдых или наоборот)
  static int daysUntilPhaseChange(DateTime today, AppSettings settings) {
    if (settings.workPeriodStartDate == null) {
      return 0;
    }

    final start = settings.workPeriodStartDate!;
    final daysSinceStart = today.difference(start).inDays;

    if (daysSinceStart < 0) {
      // дата начала в будущем → считаем до старта как до работы
      return -daysSinceStart;
    }

    switch (settings.workScheduleType) {
      case WorkScheduleType.fiveTwoSchedule:
        final weekday = today.weekday; // 1..7
        if (weekday <= 5) {
          // пн–пт → до субботы
          return 6 - weekday;
        } else {
          // сб–вс → до понедельника
          return 8 - weekday;
        }

      case WorkScheduleType.twoTwoSchedule:
        final cycle = settings.workDays + settings.restDays;
        if (cycle <= 0) return 1;
        final pos = daysSinceStart % cycle;
        if (pos < settings.workDays) {
          // сейчас рабочая фаза
          return settings.workDays - pos;
        } else {
          // сейчас отдых
          return cycle - pos;
        }

      case WorkScheduleType.shiftByDays:
        final cycle = settings.workDays + settings.restDays;
        if (cycle <= 0) return 1;
        final pos = daysSinceStart % cycle;
        if (pos < settings.workDays) {
          return settings.workDays - pos;
        } else {
          return cycle - pos;
        }

      case WorkScheduleType.shiftByMonths:
        final startDate = start;
        final startDay = startDate.day;

        int monthsPassed = (today.year - startDate.year) * 12 + (today.month - startDate.month);
        if (today.day < startDay) {
          monthsPassed--;
        }

        final monthsInPeriod = (settings.shiftMonthsPeriod / 30).round();
        if (monthsInPeriod <= 0) return 1;

        final fullCycle = monthsInPeriod * 2;
        final positionInCycle = monthsPassed % fullCycle;

        // Вычисляем дату следующей смены фазы
        int monthsUntilNextChange;
        if (positionInCycle < monthsInPeriod) {
          // Сейчас работа, следующая смена через (monthsInPeriod - positionInCycle) месяцев
          monthsUntilNextChange = monthsInPeriod - positionInCycle;
        } else {
          // Сейчас отдых, следующая смена через (fullCycle - positionInCycle) месяцев
          monthsUntilNextChange = fullCycle - positionInCycle;
        }

        // Вычисляем дату следующей смены
        DateTime nextChangeDate = DateTime(
          today.year,
          today.month + monthsUntilNextChange,
          startDay,
        );

        // Если уже прошли день смены в текущем месяце, добавляем дни до следующего дня смены
        if (today.day >= startDay) {
          nextChangeDate = DateTime(
            today.year,
            today.month + monthsUntilNextChange,
            startDay,
          );
        } else {
          // Еще не дошли до дня смены в текущем месяце
          nextChangeDate = DateTime(
            today.year,
            today.month,
            startDay,
          );
        }

        return nextChangeDate.difference(today).inDays;
    }
  }

  /// Определяет, находится ли текущий день в рабочей фазе графика
  ///
  /// Возвращает true, если сегодня рабочий период, false - если выходной
  static bool isCurrentlyWorking(DateTime today, AppSettings settings) {
    if (settings.workPeriodStartDate == null) return true;

    final daysSinceStart = today.difference(settings.workPeriodStartDate!).inDays;
    if (daysSinceStart < 0) return false;

    switch (settings.workScheduleType) {
      case WorkScheduleType.fiveTwoSchedule:
        return today.weekday <= 5;

      case WorkScheduleType.twoTwoSchedule:
        final cycle = settings.workDays + settings.restDays;
        if (cycle <= 0) return true;
        final pos = daysSinceStart % cycle;
        return pos < settings.workDays;

      case WorkScheduleType.shiftByDays:
        final cycle = settings.workDays + settings.restDays;
        if (cycle <= 0) return true;
        final pos = daysSinceStart % cycle;
        return pos < settings.workDays;

      case WorkScheduleType.shiftByMonths:
        final startDate = settings.workPeriodStartDate!;
        final startDay = startDate.day;

        int monthsPassed = (today.year - startDate.year) * 12 + (today.month - startDate.month);
        if (today.day < startDay) {
          monthsPassed--;
        }

        if (monthsPassed < 0) return false;

        final monthsInPeriod = (settings.shiftMonthsPeriod / 30).round();
        if (monthsInPeriod <= 0) return true;

        final fullCycle = monthsInPeriod * 2;
        final positionInCycle = monthsPassed % fullCycle;

        return positionInCycle < monthsInPeriod;
    }
  }
}