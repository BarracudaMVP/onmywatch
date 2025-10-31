import 'package:flutter/material.dart';
import '../widgets/mode_toggle.dart';
import '../widgets/back_to_today_button.dart';
import '../widgets/month_calendar_view.dart';
import '../widgets/year_calendar_view.dart';

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
    final today = DateTime.now();
    final isSelectedInCurrentMonth = selectedDay != null &&
        selectedDay!.year == today.year &&
        selectedDay!.month == today.month;

    return Scaffold(
      body: Column(
        children: [
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

          Expanded(
            child: Container(
              width: double.infinity,
              color: Colors.grey.shade100,
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Column(
                children: [
                  SizedBox(
                    height: 48,
                    child: Stack(
                      children: [
                        Center(
                          child: ModeToggle(
                            isYear: showYearView,
                            onChanged: (isYear) => setState(() => showYearView = isYear),
                          ),
                        ),
                        if (!isSelectedInCurrentMonth && selectedDay != null)
                          Align(
                            alignment: Alignment.centerRight,
                            child: BackToTodayButton(
                              onTap: () {
                                setState(() {
                                  selectedDay = today;
                                  focusedDay = today;
                                  showYearView = false;
                                });
                              },
                            ),
                          ),
                      ],
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
                      duration: const Duration(milliseconds: 500),
                      switchInCurve: Curves.easeInOut,
                      switchOutCurve: Curves.easeInOut,
                      transitionBuilder: (child, animation) {
                        return FadeTransition(
                          opacity: animation,
                          child: ScaleTransition(
                            scale: Tween<double>(begin: 0.95, end: 1.0).animate(
                              CurvedAnimation(parent: animation, curve: Curves.easeInOutBack),
                            ),
                            child: child,
                          ),
                        );
                      },
                      child: showYearView
                          ? YearCalendarView(
                              key: ValueKey('year_${focusedDay.year}'),
                              currentYear: focusedDay.year,
                              selectedDay: selectedDay,
                              onMonthSelected: (date) {
                                setState(() {
                                  selectedDay = DateTime(date.year, date.month, 1);
                                  showYearView = false;
                                  focusedDay = date;
                                });
                              },
                            )
                          : MonthCalendarView(
                              key: ValueKey('month_${focusedDay.year}_${focusedDay.month}'),
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