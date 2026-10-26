import 'dart:async';

import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'focus_chime.dart';
import 'planner.dart';
import 'screens/add_task_page.dart';
import 'screens/progress_page.dart';
import 'screens/subjects_page.dart';
import 'screens/today_page.dart';

class StudyBuddyApp extends StatelessWidget {
  const StudyBuddyApp({super.key, required this.planner});
  final Planner planner;

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Study Buddy',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: teal, surface: canvas),
      scaffoldBackgroundColor: canvas,
      appBarTheme: const AppBarTheme(
        backgroundColor: canvas,
        foregroundColor: ink,
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
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

class _HomeShellState extends State<HomeShell> with WidgetsBindingObserver {
  int selectedTab = 0;
  final FocusChime chime = FocusChime();
  bool alertScheduled = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    widget.planner.addListener(showPendingAlerts);
    WidgetsBinding.instance.addPostFrameCallback((_) => showPendingAlerts());
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) widget.planner.checkTimers();
  }

  void showPendingAlerts() {
    if (!widget.planner.hasAlerts || alertScheduled || !mounted) return;
    alertScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      alertScheduled = false;
      if (!mounted) return;
      var playedSound = false;
      String? message;
      while ((message = widget.planner.takeAlert()) != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message!),
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 8),
            action: SnackBarAction(
              label: 'Got it',
              onPressed: () =>
                  ScaffoldMessenger.of(context).hideCurrentSnackBar(),
            ),
          ),
        );
        if (widget.planner.soundEnabled && !playedSound) {
          unawaited(chime.play());
          playedSound = true;
        }
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    widget.planner.removeListener(showPendingAlerts);
    chime.dispose();
    super.dispose();
  }

  void openAddTask() => Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => AddTaskPage(planner: widget.planner)),
  );

  @override
  Widget build(BuildContext context) {
    final pages = [
      TodayPage(planner: widget.planner, onAdd: openAddTask),
      SubjectsPage(planner: widget.planner),
      ProgressPage(
        planner: widget.planner,
        onTestSound: () => unawaited(chime.play()),
      ),
    ];
    return Scaffold(
      appBar: AppBar(title: const AppBrand()),
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

class AppBrand extends StatelessWidget {
  const AppBrand({super.key});

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      ClipRRect(
        borderRadius: BorderRadius.circular(11),
        child: Image.asset('assets/aster_mark.png', width: 34, height: 34),
      ),
      const SizedBox(width: 10),
      const Text(
        'Study Buddy',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w800,
          color: ink,
          letterSpacing: -0.6,
        ),
      ),
    ],
  );
}
