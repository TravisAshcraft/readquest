import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class DashboardScreen extends StatelessWidget {
  final String readerName;

  const DashboardScreen({super.key, required this.readerName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: AppColors.skyBlue),
              child: Text('Hello, $readerName!',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            const ListTile(title: Text('Reading')),
            const ListTile(title: Text('Games')),
            const ListTile(title: Text('Videos')),
            const ListTile(title: Text('Parent View')),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text('Great job, $readerName! 🎉'),
        backgroundColor: AppColors.primaryPeach,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Great Job card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.primaryPeach,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Great job! 🎉",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "You've learned 4 new words and 3 colors this week.",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: 12 / 36,
                      minHeight: 12,
                      backgroundColor: Colors.white24,
                      color: AppColors.green,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "12/36 lessons completed",
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Mascot & Motivation Row
            Row(
              children: [
                SizedBox(
                  width: 100,
                  height: 100,
                  child: Image.asset(
                    "lib/assets/images/mascot.png",
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => const Icon(Icons.person, size: 100),
                  ),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Text(
                    "Keep going! You're doing awesome!",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            const Text("Topics this week:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),

            // Grid of topic cards
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 2.2,
              children: const [
                _TopicCard(title: "Human Emotions"),
                _TopicCard(title: "Story Time"),
                _TopicCard(title: "Fun with Letters"),
                _TopicCard(title: "Animal Sounds"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TopicCard extends StatelessWidget {
  final String title;

  const _TopicCard({required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cream,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(2, 2)),
        ],
      ),
      child: Center(
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
