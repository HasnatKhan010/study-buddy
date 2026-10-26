import 'package:flutter/material.dart';

import '../app_colors.dart';
import '../planner.dart';
import '../quote_carousel.dart';
import '../widgets/dashboard_widgets.dart';
import '../widgets/task_card.dart';

class TodayPage extends StatefulWidget {
  const TodayPage({super.key, required this.planner, required this.onAdd});
  final Planner planner;
  final VoidCallback onAdd;
  @override
  State<TodayPage> createState() => _TodayPageState();
}

class _TodayPageState extends State<TodayPage> {
  final searchController = TextEditingController();
  String filter = 'All';

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: widget.planner,
    builder: (context, _) {
      final planner = widget.planner;
      final query = searchController.text.trim().toLowerCase();
      final visible = planner.tasks.where((task) {
        final matchesSearch =
            task.title.toLowerCase().contains(query) ||
            task.subject.label.toLowerCase().contains(query);
        final matchesFilter =
            filter == 'All' ||
            (filter == 'To do' && !task.isDone) ||
            (filter == 'Done' && task.isDone) ||
            (filter == 'Due soon' &&
                !task.isDone &&
                task.dueDate != null &&
                task.dueDate!.isBefore(
                  DateTime.now().add(const Duration(days: 8)),
                ));
        return matchesSearch && matchesFilter;
      }).toList();
      visible.sort((a, b) {
        if (a.isDone != b.isDone) return a.isDone ? 1 : -1;
        if (a.dueDate == null) return b.dueDate == null ? 0 : 1;
        if (b.dueDate == null) return -1;
        return a.dueDate!.compareTo(b.dueDate!);
      });
      return ListView(
        padding: const EdgeInsets.fromLTRB(24, 28, 24, 110),
        children: [
          Text(
            'Make today count.',
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          const SizedBox(height: 6),
          const Text('A clear plan makes every study session easier.'),
          const SizedBox(height: 27),
          ProgressHero(planner: planner),
          const SizedBox(height: 14),
          const QuoteCarousel(),
          const SizedBox(height: 29),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Your tasks',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              Text(
                '${planner.tasks.length} total',
                style: const TextStyle(
                  color: muted,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            controller: searchController,
            onChanged: (_) => setState(() {}),
            decoration: const InputDecoration(
              hintText: 'Search tasks or subjects',
              prefixIcon: Icon(Icons.search_rounded),
            ),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            children: ['All', 'To do', 'Due soon', 'Done']
                .map(
                  (option) => ChoiceChip(
                    label: Text(option),
                    selected: filter == option,
                    onSelected: (_) => setState(() => filter = option),
                    selectedColor: const Color(0xFFD7EDE8),
                    side: BorderSide.none,
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 8),
          if (visible.isEmpty)
            EmptyCard(
              icon: planner.tasks.isEmpty
                  ? Icons.auto_awesome_outlined
                  : Icons.search_off_rounded,
              title: planner.tasks.isEmpty
                  ? 'Start with one task'
                  : 'No matching tasks',
              message: planner.tasks.isEmpty
                  ? 'Add a study goal and watch your progress grow.'
                  : 'Try another search or filter.',
              onAdd: planner.tasks.isEmpty ? widget.onAdd : null,
            )
          else
            ...visible.map(
              (task) => Padding(
                padding: const EdgeInsets.only(top: 10),
                child: TaskCard(task: task, planner: planner),
              ),
            ),
        ],
      );
    },
  );
}
