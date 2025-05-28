import 'package:flutter/material.dart';
import '../models/user.dart';
import '../widgets/progress_bar.dart';
import '../theme/app_colors.dart';

class UserProgressCard extends StatelessWidget {
  final User user;

  const UserProgressCard({super.key, required this.user});

  String getEncouragementMessage(int weeklyXp) {
    if (weeklyXp == 0) return "Let's earn some XP this week!";
    if (weeklyXp < 50) return "You're off to a good start!";
    if (weeklyXp < (100 + user.level * 10)) return "Great progress so far!";
    return "Amazing job! 🎉";
  }

  @override
  Widget build(BuildContext context) {
    final weeklyXp = user.weeklyPoints;
    final maxXp    = 100 + (user.level * 10);

    // Show exactly weeklyXp, capped at the level’s max
    final xpInLevel = weeklyXp.clamp(0, maxXp);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primaryPeach,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            getEncouragementMessage(weeklyXp),
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "You've earned $weeklyXp XP this week!",
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
          const SizedBox(height: 16),
          ProgressBar(
            xp:    xpInLevel,
            level: user.level,
            maxXp: maxXp,
          ),
          const SizedBox(height: 6),
          Text(
            "$xpInLevel / $maxXp XP",
            style: const TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 10),
          Text(
            "${user.booksRead} books read",
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
