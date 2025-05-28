import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class OptionCard extends StatelessWidget {
  final String text;
  final bool selected;
  final VoidCallback onTap;

  const OptionCard({
    Key? key,
    required this.text,
    required this.selected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: selected ? AppColors.primaryPeach : AppColors.cream,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: selected ? 4 : 1,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 20.0),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 16,
              color: selected ? Colors.white : Colors.black87,
              fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
