import 'package:flutter/material.dart';

class BackToTodayButton extends StatelessWidget {
  final VoidCallback onTap;
  const BackToTodayButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade400, width: 1.5),
          boxShadow: [
            BoxShadow(color: Colors.black12, blurRadius: 4, offset: const Offset(0, 2)),
          ],
        ),
        child: const Icon(Icons.refresh, size: 20, color: Colors.blue),
      ),
    );
  }
}