import 'package:flutter/material.dart';

import 'planner.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final planner = Planner();
  await planner.load();
  runApp(AsterApp(planner: planner));
}

const ink = Color(0xFF172B3A);
const teal = Color(0xFF117C78);
const canvas = Color(0xFFF5F7F4);
const muted = Color(0xFF667782);

class AsterApp extends StatelessWidget {
  const AsterApp({super.key, required this.planner});
  final Planner planner;

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Aster Study',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: teal, surface: canvas),
      scaffoldBackgroundColor: canvas,
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 34,
          fontWeight: FontWeight.w800,
          letterSpacing: -1.5,
          color: ink,
        ),
        headlineMedium: TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.7,
          color: ink,
        ),
        titleLarge: TextStyle(
          fontSize: 19,
          fontWeight: FontWeight.w700,
          color: ink,
        ),
        bodyMedium: TextStyle(fontSize: 14, color: muted, height: 1.45),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(18)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: Color(0xFFE2EAE6)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: teal, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 17,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: teal,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 17, horizontal: 22),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(17),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
        ),
      ),
    ),
    home: HomeShell(planner: planner),
  );
}

class HomeShell extends StatefulWidget {
  const HomeShell({super.key, required this.planner});
  final Planner planner;
  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int selectedTab = 0;

  void openAddTask() => Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => AddTaskPage(planner: widget.planner)),
  );

  @override
  Widget build(BuildContext context) {
    final pages = [
      TodayPage(planner: widget.planner, onAdd: openAddTask),
      SubjectsPage(planner: widget.planner),
      ProgressPage(planner: widget.planner),
    ];
    return Scaffold(
      body: SafeArea(child: pages[selectedTab]),
      floatingActionButton: selectedTab == 2
          ? null
          : FloatingActionButton.extended(
              onPressed: openAddTask,
              backgroundColor: teal,
              foregroundColor: Colors.white,
              icon: const Icon(Icons.add_rounded),
              label: const Text('New task'),
            ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedTab,
        onTap: (index) => setState(() => selectedTab = index),
        selectedItemColor: teal,
        unselectedItemColor: muted,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.today_outlined),
            activeIcon: Icon(Icons.today_rounded),
            label: 'Plan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.grid_view_outlined),
            activeIcon: Icon(Icons.grid_view_rounded),
            label: 'Subjects',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.insights_outlined),
            activeIcon: Icon(Icons.insights_rounded),
            label: 'Progress',
          ),
        ],
      ),
    );
  }
}

class BrandHeader extends StatelessWidget {
  const BrandHeader({super.key});
  @override
  Widget build(BuildContext context) => Row(
    children: [
      ClipRRect(
        borderRadius: BorderRadius.circular(13),
        child: Image.asset('assets/aster_mark.png', width: 38, height: 38),
      ),
      const SizedBox(width: 10),
      const Text(
        'aster',
        style: TextStyle(
          fontSize: 23,
          fontWeight: FontWeight.w900,
          color: ink,
          letterSpacing: -1,
        ),
      ),
      const Spacer(),
      const Text(
        'STUDY PLANNER',
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.4,
          color: muted,
        ),
      ),
    ],
  );
}

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
            (filter == 'Done' && task.isDone);
        return matchesSearch && matchesFilter;
      }).toList();
      return ListView(
        padding: const EdgeInsets.fromLTRB(24, 28, 24, 110),
        children: [
          const BrandHeader(),
          const SizedBox(height: 30),
          Text(
            'Make today count.',
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          const SizedBox(height: 6),
          const Text('A clear plan makes every study session easier.'),
          const SizedBox(height: 27),
          ProgressHero(planner: planner),
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
            children: ['All', 'To do', 'Done']
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

class SubjectsPage extends StatelessWidget {
  const SubjectsPage({super.key, required this.planner});
  final Planner planner;
  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: planner,
    builder: (context, _) => ListView(
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 110),
      children: [
        const BrandHeader(),
        const SizedBox(height: 30),
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
        appBar: AppBar(title: Text(subject.label), backgroundColor: canvas),
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

class ProgressPage extends StatelessWidget {
  const ProgressPage({super.key, required this.planner});
  final Planner planner;
  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: planner,
    builder: (context, _) => ListView(
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 32),
      children: [
        const BrandHeader(),
        const SizedBox(height: 30),
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
    appBar: AppBar(title: const Text('New task'), backgroundColor: canvas),
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
          const FormLabel('ESTIMATED MINUTES'),
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

class TaskDetailsPage extends StatelessWidget {
  const TaskDetailsPage({super.key, required this.task, required this.planner});
  final StudyTask task;
  final Planner planner;
  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: planner,
    builder: (context, _) => Scaffold(
      appBar: AppBar(
        title: const Text('Task details'),
        backgroundColor: canvas,
      ),
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
                    label: 'Study time',
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
            const SizedBox(height: 28),
            ElevatedButton.icon(
              onPressed: () => planner.toggleTask(task),
              icon: Icon(
                task.isDone ? Icons.undo_rounded : Icons.check_rounded,
              ),
              label: Text(
                task.isDone ? 'Move back to to do' : 'Mark as completed',
              ),
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
