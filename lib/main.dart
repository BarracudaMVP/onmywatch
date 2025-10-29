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
      localizationsDelegates: const [
        DefaultMaterialLocalizations.delegate,
        DefaultWidgetsLocalizations.delegate,
      ],
      title: 'Days Left App',
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
  int daysLeft = 30;
  bool showYearView = false; // false = Месяц, true = Год
  DateTime focusedDay = DateTime.now();

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
                  Text('$daysLeft',
                      style: const TextStyle(
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
        /* ----- ГОД + ПЕРЕКЛЮЧАТЕЛЬ (в центре) ----- */
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${focusedDay.year}',
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87),
            ),
            const SizedBox(width: 16),
            _ModeToggle(
              isYear: showYearView,
              onChanged: (isYear) => setState(() => showYearView = isYear),
            ),
          ],
        ),
        const SizedBox(height: 12),

                  /* ----- СТРЕЛКИ + НАЗВАНИЕ МЕСЯЦА ----- */
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.chevron_left),
              onPressed: showYearView
                  ? null
                  : () => setState(() => focusedDay = DateTime(
                      focusedDay.year, focusedDay.month - 1)),
              color: showYearView ? Colors.grey.shade400 : Colors.black87,
            ),
            Text(
              showYearView ? '' : _getMonthName(focusedDay.month),
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87),
            ),
            IconButton(
              icon: const Icon(Icons.chevron_right),
              onPressed: showYearView
                  ? null
                  : () => setState(() => focusedDay = DateTime(
                      focusedDay.year, focusedDay.month + 1)),
              color: showYearView ? Colors.grey.shade400 : Colors.black87,
            ),
          ],
        ),
        const SizedBox(height: 8),

        /* ----- КАЛЕНДАРЬ ----- */
        Expanded(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: showYearView
                ? const YearCalendarView(key: ValueKey('year'))
                : MonthCalendarView(
                    key: const ValueKey('month'),
                    focusedDay: focusedDay,
                    onPageChanged: (d) => setState(() => focusedDay = d),
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
/*                     ПЕРЕКЛЮЧАТЕЛЬ М / Г (единый контур)               */
class _ModeToggle extends StatelessWidget {
  final bool isYear;
  final ValueChanged<bool> onChanged;

  const _ModeToggle({required this.isYear, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade400, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _toggleItem('М', !isYear),
          _toggleItem('Г', isYear),
        ],
      ),
    );
  }

  Widget _toggleItem(String text, bool active) {
    return GestureDetector(
      onTap: () => onChanged(active),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: active ? Colors.blue.shade50 : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 15,
            fontWeight: active ? FontWeight.bold : FontWeight.normal,
            color: active ? Colors.blue.shade700 : Colors.grey.shade700,
          ),
        ),
      ),
    );
  }
}

/* --------------------------------------------------------------------- */
/*                         МЕСЯЧНЫЙ КАЛЕНДАРЬ                           */
class MonthCalendarView extends StatelessWidget {
  final DateTime focusedDay;
  final ValueChanged<DateTime> onPageChanged;

  const MonthCalendarView({
    super.key,
    required this.focusedDay,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      firstDay: DateTime.utc(2020, 1, 1),
      lastDay: DateTime.utc(2030, 12, 31),
      focusedDay: focusedDay,
      startingDayOfWeek: StartingDayOfWeek.monday,
      calendarFormat: CalendarFormat.month,
      locale: 'ru_RU',

      // Отключаем стандартный заголовок — он у нас сверху
      headerVisible: false,

      rowHeight: 46, // чтобы 6 строк влезали
      availableGestures: AvailableGestures.horizontalSwipe,
      onPageChanged: onPageChanged,

      calendarStyle: CalendarStyle(
        todayDecoration:
            BoxDecoration(color: Colors.red.shade600, shape: BoxShape.circle),
        todayTextStyle:
            const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        defaultTextStyle: const TextStyle(color: Colors.black87),
        weekendTextStyle: const TextStyle(color: Colors.black87),
        outsideTextStyle: TextStyle(color: Colors.grey.shade400),
        outsideDecoration: const BoxDecoration(shape: BoxShape.circle),
      ),

      daysOfWeekStyle: const DaysOfWeekStyle(
        weekdayStyle: TextStyle(fontWeight: FontWeight.w600, color: Colors.black87),
        weekendStyle: TextStyle(fontWeight: FontWeight.w600, color: Colors.black87),
      ),

      calendarBuilders: CalendarBuilders(
        outsideBuilder: (c, day, _) => Center(
          child: Text('${day.day}', style: TextStyle(color: Colors.grey.shade400)),
        ),
      ),
    );
  }
}

/* --------------------------------------------------------------------- */
/*                         ГОДОВОЙ КАЛЕНДАРЬ                             */
class YearCalendarView extends StatelessWidget {
  const YearCalendarView({super.key});

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
    final cur = now.month;

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
        final active = m == cur;
        return Container(
          decoration: BoxDecoration(
            color: active ? Colors.red.shade50 : Colors.white,
            border: Border.all(
                color: active ? Colors.red.shade600 : Colors.grey.shade300,
                width: active ? 2 : 1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              _getMonthName(m),
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: active ? FontWeight.bold : FontWeight.w500,
                  color: active ? Colors.red.shade700 : Colors.black87),
            ),
          ),
        );
      },
    );
  }
}