import 'package:flutter/material.dart';

import '../app_colors.dart';
import '../planner.dart';
import '../widgets/dashboard_widgets.dart';

class ProgressPage extends StatelessWidget {
  const ProgressPage({super.key, required this.planner});
  final Planner planner;
  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: planner,
    builder: (context, _) => ListView(
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 32),
      children: [
        Text(
          'See your progress.',
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        const SizedBox(height: 6),
        const Text('Small wins add up to a strong routine.'),
        const SizedBox(height: 26),
        ProgressHero(planner: planner),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: MetricCard(
                value: '${planner.completedCount}',
                label: 'Tasks done',
                icon: Icons.check_rounded,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: MetricCard(
                value: '${planner.finishedMinutes}',
                label: 'Minutes done',
                icon: Icons.timer_outlined,
              ),
            ),
          ],
        ),
        const SizedBox(height: 28),
        Text(
          'Subject breakdown',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 14),
        ...Subject.values.map((subject) {
          final subjectTasks = planner.tasks
              .where((task) => task.subject == subject)
              .toList();
          final done = subjectTasks.where((task) => task.isDone).length;
          final fraction = subjectTasks.isEmpty
              ? 0.0
              : done / subjectTasks.length;
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(17),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(subject.icon, color: teal, size: 21),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        subject.label,
                        style: const TextStyle(
                          color: ink,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Text(
                      '$done/${subjectTasks.length}',
                      style: const TextStyle(color: muted),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: fraction,
                    minHeight: 7,
                    backgroundColor: canvas,
                    color: teal,
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    ),
  );
}

class MetricCard extends StatelessWidget {
  const MetricCard({
    super.key,
    required this.value,
    required this.label,
    required this.icon,
  });
  final String value;
  final String label;
  final IconData icon;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(19),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: teal),
        const SizedBox(height: 14),
        Text(value, style: Theme.of(context).textTheme.headlineMedium),
        Text(label),
      ],
    ),
  );
}
