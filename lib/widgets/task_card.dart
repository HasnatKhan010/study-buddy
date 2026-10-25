import 'package:flutter/material.dart';

import '../app_colors.dart';
import '../planner.dart';
import '../screens/task_details_page.dart';
import '../timer_text.dart';

class TaskCard extends StatelessWidget {
  const TaskCard({super.key, required this.task, required this.planner});
  final StudyTask task;
  final Planner planner;
  @override
  Widget build(BuildContext context) => Card(
    color: Colors.white,
    elevation: 0,
    margin: EdgeInsets.zero,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    clipBehavior: Clip.antiAlias,
    child: InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => TaskDetailsPage(task: task, planner: planner),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: task.subject.color,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(task.subject.icon, color: ink),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: task.isDone ? muted : ink,
                      decoration: task.isDone
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${task.subject.label}  ·  ${task.minutes} min',
                    style: const TextStyle(fontSize: 12, color: muted),
                  ),
                  if (!task.isDone &&
                      (task.endsAt != null ||
                          task.remainingSeconds != task.minutes * 60))
                    Text(
                      task.isRunning
                          ? '${timerText(task.secondsLeft)} left'
                          : task.secondsLeft == 0
                          ? 'Time is up'
                          : '${timerText(task.secondsLeft)} paused',
                      style: const TextStyle(
                        fontSize: 12,
                        color: teal,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                ],
              ),
            ),
            IconButton(
              tooltip: task.isDone ? 'Mark as to do' : 'Mark as done',
              onPressed: () => planner.toggleTask(task),
              icon: Icon(
                task.isDone
                    ? Icons.check_circle_rounded
                    : Icons.radio_button_unchecked_rounded,
                color: teal,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
