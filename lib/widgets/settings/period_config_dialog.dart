import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../models/app_settings.dart';

class PeriodConfigDialog extends StatefulWidget {
  final AppSettings settings;
  final bool isShiftByDays;
  final Function(int workDays, int restDays, int shiftDays) onSave;

  const PeriodConfigDialog({
    super.key,
    required this.settings,
    required this.isShiftByDays,
    required this.onSave,
  });

  @override
  State<PeriodConfigDialog> createState() => _PeriodConfigDialogState();
}

class _PeriodConfigDialogState extends State<PeriodConfigDialog> {
  late TextEditingController _workDaysController;
  late TextEditingController _restDaysController;
  late TextEditingController _shiftDaysController;

  @override
  void initState() {
    super.initState();

    _workDaysController = TextEditingController(
      text: widget.settings.workDays.toString(),
    );
    _restDaysController = TextEditingController(
      text: widget.settings.restDays.toString(),
    );
    _shiftDaysController = TextEditingController(
      text: widget.settings.shiftDaysPeriod.toString(),
    );
  }

  @override
  void dispose() {
    _workDaysController.dispose();
    _restDaysController.dispose();
    _shiftDaysController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Настройка периода'),
      content: _buildTwoTwoContent(),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Назад'),
        ),
        ElevatedButton(
          onPressed: _save,
          child: const Text('Сохранить'),
        ),
      ],
    );
  }

  Widget _buildTwoTwoContent() {
    final maxValue = widget.isShiftByDays ? 999 : 10;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          controller: _workDaysController,
          decoration: InputDecoration(
            labelText: 'Рабочие дни',
            hintText: widget.isShiftByDays ? '1-999' : '0-10',
          ),
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            _RangeTextInputFormatter(widget.isShiftByDays ? 1 : 0, maxValue),
          ],
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _restDaysController,
          decoration: InputDecoration(
            labelText: 'Выходные дни',
            hintText: widget.isShiftByDays ? '1-999' : '0-10',
          ),
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            _RangeTextInputFormatter(widget.isShiftByDays ? 1 : 0, maxValue),
          ],
        ),
      ],
    );
  }

  void _save() {
    final workDays = int.tryParse(_workDaysController.text) ?? 2;
    final restDays = int.tryParse(_restDaysController.text) ?? 2;

    if (widget.isShiftByDays) {
      if (workDays >= 1 && workDays <= 999 && restDays >= 1 && restDays <= 999) {
        widget.onSave(workDays, restDays, 0);
        Navigator.pop(context);
      } else {
        _showError('Дни должны быть от 1 до 999');
      }
    } else {
      if (workDays >= 0 && workDays <= 10 && restDays >= 0 && restDays <= 10) {
        widget.onSave(workDays, restDays, 0);
        Navigator.pop(context);
      } else {
        _showError('Дни должны быть от 0 до 10');
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}

class _RangeTextInputFormatter extends TextInputFormatter {
  final int min;
  final int max;

  _RangeTextInputFormatter(this.min, this.max);

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    final value = int.tryParse(newValue.text);
    if (value == null) {
      return oldValue;
    }

    if (value < min || value > max) {
      return oldValue;
    }

    return newValue;
  }
}