import 'package:flutter/material.dart';
import '../config/app_theme.dart';

class ModeToggle extends StatelessWidget {
  final bool isYear;
  final ValueChanged<bool> onChanged;

  const ModeToggle({
    super.key,
    required this.isYear,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppDimensions.toggleButtonRadius),
        border: Border.all(color: AppColors.borderGrey, width: 1.5),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _ToggleItem(
            text: AppConstants.monthToggleLabel,
            isActive: !isYear,
            onTap: () => onChanged(false),
          ),
          _ToggleItem(
            text: AppConstants.yearToggleLabel,
            isActive: isYear,
            onTap: () => onChanged(true),
          ),
        ],
      ),
    );
  }
}

class _ToggleItem extends StatelessWidget {
  final String text;
  final bool isActive;
  final VoidCallback onTap;

  const _ToggleItem({
    required this.text,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: AppConstants.toggleDuration,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primaryBlue : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: AppDimensions.bodyFontSize,
            fontWeight: isActive ? FontWeight.bold : FontWeight.w600,
            color: isActive ? AppColors.white : AppColors.textGrey,
          ),
        ),
      ),
    );
  }
}