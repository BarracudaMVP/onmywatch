import 'package:flutter/material.dart';
import '../../models/app_settings.dart';
import 'period_config_dialog.dart';

class WorkScheduleSelector extends StatelessWidget {
  final AppSettings settings;
  final Function(AppSettings) onSettingsChanged;

  const WorkScheduleSelector({
    super.key,
    required this.settings,
    required this.onSettingsChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Выбор типа графика
        ListTile(
          title: const Text('График работы'),
          subtitle: Text(settings.getScheduleDisplayName()),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () => _showScheduleTypeDialog(context),
        ),
        const Divider(height: 1),
        
        // Настройки для 5/2
        if (settings.workScheduleType == WorkScheduleType.fiveTwoSchedule)
          SwitchListTile(
            title: const Text('С государственными праздниками'),
            subtitle: const Text('Учитывать праздничные дни'),
            value: settings.includePublicHolidays,
            onChanged: (value) {
              onSettingsChanged(settings.copyWith(includePublicHolidays: value));
            },
          ),
        
        // Настройки для 2/2
        if (settings.workScheduleType == WorkScheduleType.twoTwoSchedule) ...[
          ListTile(
            title: const Text('Настроить период'),
            subtitle: Text('Работа: ${settings.workDays} дн., Отдых: ${settings.restDays} дн.'),
            trailing: const Icon(Icons.edit, size: 20),
            onTap: () => _showPeriodConfigDialog(context, false),
          ),
          const Divider(height: 1),
          ListTile(
            title: const Text('Стартовая дата'),
            subtitle: Text(_formatDate(settings.workPeriodStartDate)),
            trailing: const Icon(Icons.calendar_today, size: 20),
            onTap: () => _selectStartDate(context),
          ),
        ],
        
        // Настройки для вахты по дням
        if (settings.workScheduleType == WorkScheduleType.shiftByDays) ...[
          ListTile(
            title: const Text('Настроить период'),
            subtitle: Text('Период: ${settings.shiftDaysPeriod} дней'),
            trailing: const Icon(Icons.edit, size: 20),
            onTap: () => _showPeriodConfigDialog(context, true),
          ),
          const Divider(height: 1),
          ListTile(
            title: const Text('Стартовая дата'),
            subtitle: Text(_formatDate(settings.workPeriodStartDate)),
            trailing: const Icon(Icons.calendar_today, size: 20),
            onTap: () => _selectStartDate(context),
          ),
        ],
        
        // Настройки для вахты по месяцам
        if (settings.workScheduleType == WorkScheduleType.shiftByMonths) ...[
          ListTile(
            title: const Text('Период работы'),
            subtitle: Text('${settings.shiftMonthsPeriod} дней'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () => _showMonthsPeriodDialog(context),
          ),
          const Divider(height: 1),
          ListTile(
            title: const Text('Стартовая дата'),
            subtitle: Text(_formatDate(settings.workPeriodStartDate)),
            trailing: const Icon(Icons.calendar_today, size: 20),
            onTap: () => _selectStartDate(context),
          ),
        ],
      ],
    );
  }

  void _showScheduleTypeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Выберите график работы'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildScheduleOption(context, WorkScheduleType.fiveTwoSchedule, '5/2'),
            _buildScheduleOption(context, WorkScheduleType.twoTwoSchedule, '2/2'),
            _buildScheduleOption(context, WorkScheduleType.shiftByDays, 'Вахтовый график по дням'),
            _buildScheduleOption(context, WorkScheduleType.shiftByMonths, 'Вахтовый график по месяцам'),
          ],
        ),
      ),
    );
  }

  Widget _buildScheduleOption(BuildContext context, WorkScheduleType type, String label) {
    return RadioListTile<WorkScheduleType>(
      title: Text(label),
      value: type,
      groupValue: settings.workScheduleType,
      onChanged: (value) {
        if (value != null) {
          var newSettings = settings.copyWith(workScheduleType: value);
          
          // Включаем праздники при выборе 5/2
          if (value == WorkScheduleType.fiveTwoSchedule) {
            newSettings = newSettings.copyWith(includePublicHolidays: true);
          }
          
          onSettingsChanged(newSettings);
          Navigator.pop(context);
        }
      },
    );
  }

  void _showPeriodConfigDialog(BuildContext context, bool isShiftByDays) {
    showDialog(
      context: context,
      builder: (context) => PeriodConfigDialog(
        settings: settings,
        isShiftByDays: isShiftByDays,
        onSave: (workDays, restDays, shiftDays) {
          if (isShiftByDays) {
            onSettingsChanged(settings.copyWith(shiftDaysPeriod: shiftDays));
          } else {
            onSettingsChanged(settings.copyWith(
              workDays: workDays,
              restDays: restDays,
            ));
          }
        },
      ),
    );
  }

  void _showMonthsPeriodDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Период работы'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<int>(
              title: const Text('30 дней'),
              value: 30,
              groupValue: settings.shiftMonthsPeriod,
              onChanged: (value) {
                if (value != null) {
                  onSettingsChanged(settings.copyWith(shiftMonthsPeriod: value));
                  Navigator.pop(context);
                }
              },
            ),
            RadioListTile<int>(
              title: const Text('60 дней'),
              value: 60,
              groupValue: settings.shiftMonthsPeriod,
              onChanged: (value) {
                if (value != null) {
                  onSettingsChanged(settings.copyWith(shiftMonthsPeriod: value));
                  Navigator.pop(context);
                }
              },
            ),
            RadioListTile<int>(
              title: const Text('90 дней'),
              value: 90,
              groupValue: settings.shiftMonthsPeriod,
              onChanged: (value) {
                if (value != null) {
                  onSettingsChanged(settings.copyWith(shiftMonthsPeriod: value));
                  Navigator.pop(context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: settings.workPeriodStartDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      locale: const Locale('ru', 'RU'),
    );

    if (picked != null) {
      onSettingsChanged(settings.copyWith(workPeriodStartDate: picked));
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Не задана';
    return '${date.day}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }
}