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
    
    if (widget.isShiftByDays) {
      _shiftDaysController = TextEditingController(
        text: widget.settings.shiftDaysPeriod.toString(),
      );
    } else {
      _workDaysController = TextEditingController(
        text: widget.settings.workDays.toString(),
      );
      _restDaysController = TextEditingController(
        text: widget.settings.restDays.toString(),
      );
    }
  }

  @override
  void dispose() {
    if (widget.isShiftByDays) {
      _shiftDaysController.dispose();
    } else {
      _workDaysController.dispose();
      _restDaysController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Настройка периода'),
      content: widget.isShiftByDays
          ? _buildShiftByDaysContent()
          : _buildTwoTwoContent(),
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
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          controller: _workDaysController,
          decoration: const InputDecoration(
            labelText: 'Рабочие дни',
            hintText: '0-10',
          ),
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            _RangeTextInputFormatter(0, 10),
          ],
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _restDaysController,
          decoration: const InputDecoration(
            labelText: 'Выходные дни',
            hintText: '0-10',
          ),
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            _RangeTextInputFormatter(0, 10),
          ],
        ),
      ],
    );
  }

  Widget _buildShiftByDaysContent() {
    return TextField(
      controller: _shiftDaysController,
      decoration: const InputDecoration(
        labelText: 'Период в днях',
        hintText: '11-999',
      ),
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        _RangeTextInputFormatter(11, 999),
      ],
    );
  }

  void _save() {
    if (widget.isShiftByDays) {
      final shiftDays = int.tryParse(_shiftDaysController.text) ?? 30;
      if (shiftDays >= 11 && shiftDays <= 999) {
        widget.onSave(0, 0, shiftDays);
        Navigator.pop(context);
      } else {
        _showError('Период должен быть от 11 до 999 дней');
      }
    } else {
      final workDays = int.tryParse(_workDaysController.text) ?? 2;
      final restDays = int.tryParse(_restDaysController.text) ?? 2;
      
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