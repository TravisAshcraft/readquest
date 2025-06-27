import 'package:flutter/material.dart';
import '../models/child.dart';               // your Child model
import 'pairing_code_widget.dart';

class ChildCard extends StatelessWidget {
  final Child child;
  final VoidCallback onTap;

  const ChildCard({Key? key, required this.child, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(child.name, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              Chip(
                label: Text(child.pairingCode.isNotEmpty ? 'Activated' : 'Not Connected'),
                backgroundColor: child.pairingCode.isNotEmpty ? Colors.green[100] : Colors.grey[300],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
