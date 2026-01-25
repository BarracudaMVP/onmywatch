import 'package:flutter/material.dart';
import '../config/app_theme.dart';

class BackToTodayButton extends StatelessWidget {
  final VoidCallback onTap;
  
  const BackToTodayButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: AppDimensions.iconButtonSize,
        height: AppDimensions.iconButtonSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.white,
          border: Border.all(color: AppColors.borderGrey, width: 1.5),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Icon(
          Icons.refresh,
          size: AppDimensions.smallIconSize,
          color: Colors.blue,
        ),
      ),
    );
  }
}