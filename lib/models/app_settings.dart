import 'package:flutter/material.dart';

enum WorkScheduleType {
  fiveTwoSchedule,      // 5/2
  twoTwoSchedule,       // 2/2
  shiftByDays,          // Вахта по дням
  shiftByMonths,        // Вахта по месяцам
}

class AppSettings {
  final Color primaryColor;
  final Color secondaryColor;
  final Color workdayTextColor;
  final Color weekendTextColor;

  // Настройки календаря
  final WorkScheduleType workScheduleType;
  final bool includePublicHolidays;
  final int workDays;
  final int restDays;
  final int shiftDaysPeriod;
  final int shiftMonthsPeriod;
  final DateTime? workPeriodStartDate;

  const AppSettings({
    required this.primaryColor,
    required this.secondaryColor,
    this.workdayTextColor = const Color(0xFF424242),
    this.weekendTextColor = const Color(0xFFE53935),
    this.workScheduleType = WorkScheduleType.fiveTwoSchedule,
    this.includePublicHolidays = true,
    this.workDays = 2,
    this.restDays = 2,
    this.shiftDaysPeriod = 30,
    this.shiftMonthsPeriod = 30,
    this.workPeriodStartDate,
  });

  factory AppSettings.defaults() {
    return AppSettings(
      primaryColor: Colors.blue.shade600,
      secondaryColor: Colors.white,
      workdayTextColor: const Color(0xFF424242),
      weekendTextColor: const Color(0xFFE53935),
      workScheduleType: WorkScheduleType.fiveTwoSchedule,
      includePublicHolidays: true,
      workDays: 2,
      restDays: 2,
      shiftDaysPeriod: 30,
      shiftMonthsPeriod: 30,
      workPeriodStartDate: DateTime.now(),
    );
  }

  factory AppSettings.fromJson(Map<String, dynamic> json) {
    return AppSettings(
      primaryColor: Color(json['primaryColor'] ?? 0xFF1E88E5),
      secondaryColor: Color(json['secondaryColor'] ?? 0xFFFFFFFF),
      workdayTextColor: Color(json['workdayTextColor'] ?? 0xFF424242),
      weekendTextColor: Color(json['weekendTextColor'] ?? 0xFFE53935),
      workScheduleType: WorkScheduleType.values[json['workScheduleType'] ?? 0],
      includePublicHolidays: json['includePublicHolidays'] ?? true,
      workDays: json['workDays'] ?? 2,
      restDays: json['restDays'] ?? 2,
      shiftDaysPeriod: json['shiftDaysPeriod'] ?? 30,
      shiftMonthsPeriod: json['shiftMonthsPeriod'] ?? 30,
      workPeriodStartDate: json['workPeriodStartDate'] != null
          ? DateTime.parse(json['workPeriodStartDate'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'primaryColor': primaryColor.value,
      'secondaryColor': secondaryColor.value,
      'workdayTextColor': workdayTextColor.value,
      'weekendTextColor': weekendTextColor.value,
      'workScheduleType': workScheduleType.index,
      'includePublicHolidays': includePublicHolidays,
      'workDays': workDays,
      'restDays': restDays,
      'shiftDaysPeriod': shiftDaysPeriod,
      'shiftMonthsPeriod': shiftMonthsPeriod,
      'workPeriodStartDate': workPeriodStartDate?.toIso8601String(),
    };
  }

  AppSettings copyWith({
    Color? primaryColor,
    Color? secondaryColor,
    Color? workdayTextColor,
    Color? weekendTextColor,
    WorkScheduleType? workScheduleType,
    bool? includePublicHolidays,
    int? workDays,
    int? restDays,
    int? shiftDaysPeriod,
    int? shiftMonthsPeriod,
    DateTime? workPeriodStartDate,
  }) {
    return AppSettings(
      primaryColor: primaryColor ?? this.primaryColor,
      secondaryColor: secondaryColor ?? this.secondaryColor,
      workdayTextColor: workdayTextColor ?? this.workdayTextColor,
      weekendTextColor: weekendTextColor ?? this.weekendTextColor,
      workScheduleType: workScheduleType ?? this.workScheduleType,
      includePublicHolidays: includePublicHolidays ?? this.includePublicHolidays,
      workDays: workDays ?? this.workDays,
      restDays: restDays ?? this.restDays,
      shiftDaysPeriod: shiftDaysPeriod ?? this.shiftDaysPeriod,
      shiftMonthsPeriod: shiftMonthsPeriod ?? this.shiftMonthsPeriod,
      workPeriodStartDate: workPeriodStartDate ?? this.workPeriodStartDate,
    );
  }
  
  String getScheduleDisplayName() {
    switch (workScheduleType) {
      case WorkScheduleType.fiveTwoSchedule:
        return 'Стандартный график';
      case WorkScheduleType.twoTwoSchedule:
        return 'Сменный график';
      case WorkScheduleType.shiftByDays:
        return 'Вахтовый график по дням';
      case WorkScheduleType.shiftByMonths:
        return 'Вахтовый график по месяцам';
    }
  }
}