import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  initializeDateFormatting('ru_RU', null).then((_) => runApp(const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: const Locale('ru', 'RU'),
      supportedLocales: const [Locale('ru', 'RU')],
      localizationsDelegates: [
        DefaultMaterialLocalizations.delegate,
        DefaultWidgetsLocalizations.delegate,
      ],
      title: 'On My Watch',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

/* --------------------------------------------------------------------- */
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime focusedDay = DateTime.now();
  DateTime? selectedDay;
  bool showYearView = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          /* -------------------- ВЕРХНЯЯ ПОЛОВИНА -------------------- */
          Expanded(
            child: Container(
              width: double.infinity,
              color: Colors.blue.shade600,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Осталось дней',
                      style: TextStyle(fontSize: 24, color: Colors.white70)),
                  const SizedBox(height: 16),
                  const Text('30',
                      style: TextStyle(
                          fontSize: 96,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                ],
              ),
            ),
          ),

          /* -------------------- НИЖНЯЯ ПОЛОВИНА -------------------- */
          Expanded(
            child: Container(
              width: double.infinity,
              color: Colors.grey.shade100,
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Column(
                children: [
                  Center(
                    child: _ModeToggle(
                      isYear: showYearView,
                      onChanged: (isYear) => setState(() => showYearView = isYear),
                    ),
                  ),
                  const SizedBox(height: 12),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.chevron_left),
                        onPressed: () => _changePeriod(-1),
                        color: Colors.black87,
                      ),
                      Text(
                        showYearView
                            ? '${focusedDay.year}'
                            : '${_getMonthName(focusedDay.month)} ${focusedDay.year}',
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87),
                      ),
                      IconButton(
                        icon: const Icon(Icons.chevron_right),
                        onPressed: () => _changePeriod(1),
                        color: Colors.black87,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  Expanded(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: showYearView
                          ? YearCalendarView(
                              key: const ValueKey('year'),
                              currentYear: focusedDay.year,
                              selectedDay: selectedDay,
                              onMonthSelected: (date) {
                                setState(() {
                                  // ← КЛИК ПО МЕСЯЦУ: 1-е число
                                  selectedDay = DateTime(date.year, date.month, 1);
                                  showYearView = false;
                                  focusedDay = date;
                                });
                              },
                            )
                          : MonthCalendarView(
                              key: const ValueKey('month'),
                              focusedDay: focusedDay,
                              selectedDay: selectedDay,
                              onDaySelected: (day, focused) {
                                setState(() {
                                  selectedDay = day;
                                  focusedDay = focused;
                                });
                              },
                              onPageChanged: (d) {
                                setState(() {
                                  focusedDay = d;
                                  // ← СМЕНА МЕСЯЦА: 1-е число
                                  selectedDay = DateTime(d.year, d.month, 1);
                                });
                              },
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _changePeriod(int delta) {
    setState(() {
      if (showYearView) {
        focusedDay = DateTime(focusedDay.year + delta);
      } else {
        focusedDay = DateTime(focusedDay.year, focusedDay.month + delta);
        // ← СМЕНА СТРЕЛКАМИ: 1-е число
        selectedDay = DateTime(focusedDay.year, focusedDay.month, 1);
      }
    });
  }

  String _getMonthName(int month) {
    const months = [
      'Январь', 'Февраль', 'Март', 'Апрель',
      'Май', 'Июнь', 'Июль', 'Август',
      'Сентябрь', 'Октябрь', 'Ноябрь', 'Декабрь'
    ];
    return months[month - 1];
  }
}

/* --------------------------------------------------------------------- */
class _ModeToggle extends StatelessWidget {
  final bool isYear;
  final ValueChanged<bool> onChanged;

  const _ModeToggle({required this.isYear, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade400, width: 1.5),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: const Offset(0, 2)),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _toggleItem('М', !isYear, () => onChanged(false)),
          _toggleItem('Г', isYear, () => onChanged(true)),
        ],
      ),
    );
  }

  Widget _toggleItem(String text, bool active, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: active ? Colors.blue.shade600 : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 16,
            fontWeight: active ? FontWeight.bold : FontWeight.w600,
            color: active ? Colors.white : Colors.grey.shade700,
          ),
        ),
      ),
    );
  }
}

/* --------------------------------------------------------------------- */
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
    final isTodaySelected = isSameDay(selectedDay, today);

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
        // ← СПЕЦИАЛЬНАЯ ПОДСВЕТКА: Сегодня + Выбран
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

/* --------------------------------------------------------------------- */
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

        // ← СПЕЦИАЛЬНЫЙ СЛУЧАЙ: Текущий месяц + Выбран
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