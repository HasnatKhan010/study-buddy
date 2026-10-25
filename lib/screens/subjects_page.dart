import 'package:flutter/material.dart';

import '../app_colors.dart';
import '../planner.dart';
import '../widgets/dashboard_widgets.dart';
import '../widgets/task_card.dart';

class SubjectsPage extends StatelessWidget {
  const SubjectsPage({super.key, required this.planner});
  final Planner planner;
  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: planner,
    builder: (context, _) => ListView(
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 110),
      children: [
        Text(
          'Study by subject.',
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        const SizedBox(height: 6),
        const Text('Keep every part of your plan in view.'),
        const SizedBox(height: 26),
        LayoutBuilder(
          builder: (context, constraints) => GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: Subject.values.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: constraints.maxWidth > 560 ? 4 : 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.95,
            ),
            itemBuilder: (context, index) {
              final subject = Subject.values[index];
              final count = planner.tasks
                  .where((task) => task.subject == subject)
                  .length;
              final done = planner.tasks
                  .where((task) => task.subject == subject && task.isDone)
                  .length;
              return Material(
                color: subject.color,
                borderRadius: BorderRadius.circular(22),
                child: InkWell(
                  borderRadius: BorderRadius.circular(22),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SubjectDetailsPage(
                        subject: subject,
                        planner: planner,
                      ),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(subject.icon, size: 29, color: ink),
                        const Spacer(),
                        Text(
                          subject.label,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                            color: ink,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '$done / $count done',
                          style: const TextStyle(color: ink, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Row(
            children: [
              Icon(Icons.lightbulb_outline_rounded, color: teal),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Tap a subject to see its tasks and track what is left.',
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class SubjectDetailsPage extends StatelessWidget {
  const SubjectDetailsPage({
    super.key,
    required this.subject,
    required this.planner,
  });
  final Subject subject;
  final Planner planner;
  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: planner,
    builder: (context, _) {
      final tasks = planner.tasks
          .where((task) => task.subject == subject)
          .toList();
      return Scaffold(
        appBar: AppBar(title: Text(subject.label)),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: subject.color,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                children: [
                  Icon(subject.icon, size: 38),
                  const SizedBox(width: 16),
                  Text(
                    '${tasks.length} tasks',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            if (tasks.isEmpty)
              const EmptyCard(
                icon: Icons.inbox_outlined,
                title: 'Nothing here yet',
                message: 'Add a task in Plan and choose this subject.',
              )
            else
              ...tasks.map(
                (task) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: TaskCard(task: task, planner: planner),
                ),
              ),
          ],
        ),
      );
    },
  );
}
