import 'package:flutter/material.dart';

import '../app_colors.dart';
import '../planner.dart';

class ProgressHero extends StatelessWidget {
  const ProgressHero({super.key, required this.planner});
  final Planner planner;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(24),
    decoration: BoxDecoration(
      color: ink,
      borderRadius: BorderRadius.circular(28),
    ),
    child: Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'YOUR MOMENTUM',
                style: TextStyle(
                  color: Color(0xFF9DCDC7),
                  fontWeight: FontWeight.w800,
                  fontSize: 10,
                  letterSpacing: 1.6,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                '${planner.completedCount} of ${planner.tasks.length} done',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 23,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${planner.finishedMinutes} / ${planner.plannedMinutes} study minutes',
                style: const TextStyle(color: Color(0xFFB8C7CE), fontSize: 13),
              ),
              const SizedBox(height: 17),
              const Row(
                children: [
                  Icon(Icons.bolt_rounded, size: 16, color: Color(0xFFFFD38A)),
                  SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      'One step at a time',
                      style: TextStyle(
                        color: Color(0xFFFFD38A),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        SizedBox(
          width: 78,
          height: 78,
          child: Stack(
            fit: StackFit.expand,
            children: [
              CircularProgressIndicator(
                value: planner.progress,
                strokeWidth: 8,
                backgroundColor: const Color(0xFF425767),
                valueColor: const AlwaysStoppedAnimation(Color(0xFF77D8C5)),
                strokeCap: StrokeCap.round,
              ),
              Center(
                child: Text(
                  '${(planner.progress * 100).round()}%',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 17,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class EmptyCard extends StatelessWidget {
  const EmptyCard({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.onAdd,
  });
  final IconData icon;
  final String title;
  final String message;
  final VoidCallback? onAdd;
  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    margin: const EdgeInsets.only(top: 8),
    padding: const EdgeInsets.all(28),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(22),
    ),
    child: Column(
      children: [
        Icon(icon, size: 38, color: teal),
        const SizedBox(height: 12),
        Text(title, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 4),
        Text(message, textAlign: TextAlign.center),
        if (onAdd != null) ...[
          const SizedBox(height: 18),
          ElevatedButton(
            onPressed: onAdd,
            child: const Text('Add your first task'),
          ),
        ],
      ],
    ),
  );
}
