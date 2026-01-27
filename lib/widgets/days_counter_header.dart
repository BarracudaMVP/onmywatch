import 'package:flutter/material.dart';
import '../config/app_theme.dart';
import '../models/app_settings.dart';
import '../utils/date_utils.dart';

class DaysCounterHeader extends StatelessWidget {
  final AppColors colors;
  final AppSettings settings;

  const DaysCounterHeader({
    super.key,
    required this.colors,
    required this.settings,
  });

  @override
  Widget build(BuildContext context) {
    final daysLeft = AppDateUtils.daysUntilPhaseChange(DateTime.now(), settings);

    return Container(
      width: double.infinity,
      color: colors.primaryColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            AppConstants.daysLeftLabel,
            style: TextStyle(
              fontSize: AppDimensions.titleFontSize,
              color: AppColors.white70,
            ),
          ),
          const SizedBox(height: AppDimensions.paddingMedium),
          Text(
            '$daysLeft',
            style: TextStyle(
              fontSize: AppDimensions.headerFontSize,
              fontWeight: FontWeight.bold,
              color: AppColors.white,
            ),
          ),
        ],
      ),
    );
  }
}