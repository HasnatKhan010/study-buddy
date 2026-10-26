import 'package:flutter/material.dart';

import '../app_colors.dart';
import '../planner.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({super.key, required this.planner, this.task});
  final Planner planner;
  final StudyTask? task;
  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  late final TextEditingController titleController;
  late final TextEditingController minutesController;
  late final TextEditingController notesController;
  late Subject selectedSubject;
  DateTime? selectedDueDate;
  String? error;

  @override
  void initState() {
    super.initState();
    final task = widget.task;
    titleController = TextEditingController(text: task?.title ?? '');
    minutesController = TextEditingController(
      text: (task?.minutes ?? 30).toString(),
    );
    notesController = TextEditingController(text: task?.notes ?? '');
    selectedSubject = task?.subject ?? Subject.coding;
    selectedDueDate = task?.dueDate;
  }

  @override
  void dispose() {
    titleController.dispose();
    minutesController.dispose();
    notesController.dispose();
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
    if (widget.task == null) {
      widget.planner.addTask(
        title,
        selectedSubject,
        minutes,
        notes: notesController.text,
        dueDate: selectedDueDate,
      );
    } else {
      widget.planner.updateTask(
        widget.task!,
        title,
        selectedSubject,
        minutes,
        notes: notesController.text,
        dueDate: selectedDueDate,
      );
    }
    Navigator.pop(context);
  }

  Future<void> chooseDueDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: selectedDueDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (date != null) setState(() => selectedDueDate = date);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(widget.task == null ? 'New task' : 'Edit task')),
    body: SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(24, 22, 24, 30),
        children: [
          Text(
            widget.task == null ? 'Plan a small win.' : 'Make your plan fit.',
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
          if (widget.task != null)
            const Text('Changing the timer length resets its countdown.'),
          const SizedBox(height: 20),
          const FormLabel('DUE DATE (OPTIONAL)'),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              OutlinedButton.icon(
                onPressed: chooseDueDate,
                icon: const Icon(Icons.calendar_today_outlined),
                label: Text(
                  selectedDueDate == null
                      ? 'Choose date'
                      : MaterialLocalizations.of(context)
                            .formatMediumDate(selectedDueDate!),
                ),
              ),
              if (selectedDueDate != null)
                TextButton(
                  onPressed: () => setState(() => selectedDueDate = null),
                  child: const Text('Clear'),
                ),
            ],
          ),
          const SizedBox(height: 18),
          const FormLabel('NOTES (OPTIONAL)'),
          const SizedBox(height: 9),
          TextField(
            controller: notesController,
            maxLines: 3,
            maxLength: 300,
            decoration: const InputDecoration(
              hintText: 'What will you work on?',
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
            label: Text(
              widget.task == null ? 'Add to my plan' : 'Save changes',
            ),
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
