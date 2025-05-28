import 'package:flutter/material.dart';

class ProgressBar extends StatelessWidget {
  final int xp;
  final int maxXp;
  final int level;

  const ProgressBar({
    super.key,
    required this.xp,
    required this.level,
    required this.maxXp,
  });

  @override
  Widget build(BuildContext context) {
    // Before (integer division = wrong):
    // final double fillPercent = xp ~/ maxXp;

    // After (floating division = correct):
    final double fillPercent = xp / maxXp;

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: LinearProgressIndicator(
        minHeight: 8,
        backgroundColor: Colors.white24,
        valueColor: AlwaysStoppedAnimation(Colors.green),
        value: fillPercent.clamp(0.0, 1.0),
      ),
    );
  }
}