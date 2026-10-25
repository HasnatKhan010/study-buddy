import 'package:flutter/material.dart';

import '../app_colors.dart';
import '../planner.dart';
import '../timer_text.dart';

class TaskTimerCard extends StatelessWidget {
  const TaskTimerCard({super.key, required this.task, required this.planner});
  final StudyTask task;
  final Planner planner;

  @override
  Widget build(BuildContext context) {
    final left = task.secondsLeft;
    final total = task.minutes * 60;
    final status = task.isDone
        ? 'COMPLETED'
        : task.isRunning
        ? 'RUNNING'
        : left == 0
        ? "TIME'S UP"
        : left < total
        ? 'PAUSED'
        : 'READY';

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: const Color(0xFFE5F2E9),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.timer_outlined, color: teal, size: 19),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'FOCUS TIMER',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.2,
                    color: teal,
                  ),
                ),
              ),
              Text(
                status,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  color: teal,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            timerText(left),
            style: const TextStyle(
              fontSize: 43,
              fontWeight: FontWeight.w800,
              letterSpacing: -1.5,
              color: ink,
            ),
          ),
          const SizedBox(height: 5),
          Text('${task.minutes} minute focus session'),
          if (task.isRunning) ...[
            const SizedBox(height: 4),
            Text(
              'Ends at ${TimeOfDay.fromDateTime(task.endsAt!.toLocal()).format(context)}',
              style: const TextStyle(color: teal, fontWeight: FontWeight.w700),
            ),
          ],
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: (1 - left / total).clamp(0.0, 1.0),
              minHeight: 7,
              color: teal,
              backgroundColor: const Color(0xFFBFDBC8),
            ),
          ),
          if (!task.isDone) ...[
            const SizedBox(height: 18),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton.icon(
                  onPressed: () => task.isRunning
                      ? planner.pauseTimer(task)
                      : planner.startTimer(task),
                  icon: Icon(
                    task.isRunning
                        ? Icons.pause_rounded
                        : Icons.play_arrow_rounded,
                  ),
                  label: Text(
                    task.isRunning
                        ? 'Pause timer'
                        : left == total || left == 0
                        ? 'Start timer'
                        : 'Resume timer',
                  ),
                ),
                if (left != total || task.isRunning)
                  TextButton(
                    onPressed: () => planner.resetTimer(task),
                    child: const Text('Reset'),
                  ),
              ],
            ),
            if (left == 0) ...[
              const SizedBox(height: 9),
              const Text('Time is up. Finish the task when you are ready.'),
            ],
          ],
        ],
      ),
    );
  }
}

class TaskDetailsPage extends StatelessWidget {
  const TaskDetailsPage({super.key, required this.task, required this.planner});
  final StudyTask task;
  final Planner planner;
  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: planner,
    builder: (context, _) => Scaffold(
      appBar: AppBar(title: const Text('Task details')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 30),
          children: [
            Container(
              width: 72,
              height: 72,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: task.subject.color,
                borderRadius: BorderRadius.circular(22),
              ),
              child: Icon(task.subject.icon, size: 36),
            ),
            const SizedBox(height: 23),
            Text(task.title, style: Theme.of(context).textTheme.headlineLarge),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  DetailRow(
                    icon: Icons.category_outlined,
                    label: 'Subject',
                    value: task.subject.label,
                  ),
                  const Divider(height: 28),
                  DetailRow(
                    icon: Icons.timer_outlined,
                    label: 'Timer length',
                    value: '${task.minutes} minutes',
                  ),
                  const Divider(height: 28),
                  DetailRow(
                    icon: Icons.flag_outlined,
                    label: 'Status',
                    value: task.isDone ? 'Completed' : 'To do',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            TaskTimerCard(task: task, planner: planner),
            const SizedBox(height: 28),
            ElevatedButton.icon(
              onPressed: () => task.isDone
                  ? planner.toggleTask(task)
                  : planner.finishTask(task),
              icon: Icon(
                task.isDone ? Icons.undo_rounded : Icons.check_rounded,
              ),
              label: Text(task.isDone ? 'Move back to to do' : 'Finish task'),
            ),
            const SizedBox(height: 12),
            TextButton.icon(
              onPressed: () {
                planner.deleteTask(task);
                Navigator.pop(context);
              },
              icon: const Icon(Icons.delete_outline_rounded),
              label: const Text('Delete task'),
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFFB53939),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class DetailRow extends StatelessWidget {
  const DetailRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });
  final IconData icon;
  final String label;
  final String value;
  @override
  Widget build(BuildContext context) => Row(
    children: [
      Icon(icon, color: teal, size: 21),
      const SizedBox(width: 11),
      Expanded(child: Text(label)),
      Text(
        value,
        style: const TextStyle(color: ink, fontWeight: FontWeight.w700),
      ),
    ],
  );
}
