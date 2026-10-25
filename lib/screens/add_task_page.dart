import 'package:flutter/material.dart';

import '../app_colors.dart';
import '../planner.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({super.key, required this.planner});
  final Planner planner;
  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final titleController = TextEditingController();
  final minutesController = TextEditingController(text: '30');
  Subject selectedSubject = Subject.coding;
  String? error;

  @override
  void dispose() {
    titleController.dispose();
    minutesController.dispose();
    super.dispose();
  }

  void saveTask() {
    final title = titleController.text.trim();
    final minutes = int.tryParse(minutesController.text.trim());
    if (title.isEmpty || minutes == null || minutes < 1 || minutes > 600) {
      setState(
        () => error = 'Enter a task and a duration from 1 to 600 minutes.',
      );
      return;
    }
    widget.planner.addTask(title, selectedSubject, minutes);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('New task')),
    body: SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(24, 22, 24, 30),
        children: [
          Text(
            'Plan a small win.',
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          const SizedBox(height: 7),
          const Text('Give your next study session a clear purpose.'),
          const SizedBox(height: 30),
          const FormLabel('TASK NAME'),
          const SizedBox(height: 9),
          TextField(
            controller: titleController,
            autofocus: true,
            textCapitalization: TextCapitalization.sentences,
            maxLength: 70,
            decoration: const InputDecoration(
              hintText: 'e.g. Practice Flutter layouts',
            ),
          ),
          const SizedBox(height: 10),
          const FormLabel('SUBJECT'),
          const SizedBox(height: 10),
          Wrap(
            spacing: 9,
            runSpacing: 8,
            children: Subject.values
                .map(
                  (subject) => ChoiceChip(
                    avatar: Icon(subject.icon, size: 18),
                    label: Text(subject.label),
                    selected: selectedSubject == subject,
                    selectedColor: subject.color,
                    side: BorderSide.none,
                    onSelected: (_) =>
                        setState(() => selectedSubject = subject),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 26),
          const FormLabel('TIMER LENGTH IN MINUTES'),
          const SizedBox(height: 9),
          TextField(
            controller: minutesController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              hintText: '30',
              suffixText: 'min',
            ),
          ),
          if (error != null) ...[
            const SizedBox(height: 15),
            Text(
              error!,
              style: const TextStyle(
                color: Color(0xFFB53939),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: saveTask,
            icon: const Icon(Icons.add_rounded),
            label: const Text('Add to my plan'),
          ),
        ],
      ),
    ),
  );
}

class FormLabel extends StatelessWidget {
  const FormLabel(this.text, {super.key});
  final String text;
  @override
  Widget build(BuildContext context) => Text(
    text,
    style: const TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.w800,
      letterSpacing: 1.2,
      color: ink,
    ),
  );
}
