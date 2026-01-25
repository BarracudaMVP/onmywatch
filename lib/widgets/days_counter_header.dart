import 'package:flutter/material.dart';
import '../config/app_theme.dart';

class DaysCounterHeader extends StatelessWidget {
  final int daysLeft;
  
  const DaysCounterHeader({
    super.key,
    this.daysLeft = 30,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.primaryBlue,
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