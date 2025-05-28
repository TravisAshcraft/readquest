import 'dart:math';

import 'package:flutter/material.dart';
import '../models/user.dart';

class MascotMotivationCard extends StatelessWidget {
  final User user;

  const MascotMotivationCard({super.key, required this.user});

  String getMotivationText() {
    final rand = Random();

    if (user.weeklyPoints == 0) {
      final options = [
        "Let's start reading something fun!",
        "Pick a book and dive into an adventure! 📖",
        "Your next great story is waiting!",
      ];
      return options[rand.nextInt(options.length)];
    }

    if (user.booksRead < 3) {
      final options = [
        "You're just getting started – keep it up!",
        "A great beginning! Time to stack those stories!",
        "You've cracked open the door — keep turning those pages!",
      ];
      return options[rand.nextInt(options.length)];
    }

    if (user.booksRead < 10) {
      final options = [
        "You're doing awesome! 📚",
        "Look at you go! Keep the momentum!",
        "You're on a reading roll!",
      ];
      return options[rand.nextInt(options.length)];
    }

    if (user.totalPoints > 500) {
      final options = [
        "You're a reading rockstar! 🌟",
        "Legendary reader alert! 🚀",
        "You've unlocked ultimate reading power!",
      ];
      return options[rand.nextInt(options.length)];
    }

    final fallback = [
      "Keep going! Every book makes you smarter!",
      "So many stories, so much learning — keep going!",
      "You’ve come so far — the next chapter awaits!",
    ];
    return fallback[rand.nextInt(fallback.length)];
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 100,
          height: 100,
          child: Image.asset(
            "lib/assets/images/mascot.png",
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) =>
            const Icon(Icons.person, size: 100),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            getMotivationText(),
            style: const TextStyle(fontSize: 18),
          ),
        ),
      ],
    );
  }
}
