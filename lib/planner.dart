import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum Subject {
  coding('Coding', Icons.code_rounded, Color(0xFFB8E5DC)),
  design('Design', Icons.palette_outlined, Color(0xFFF7DBBE)),
  writing('Writing', Icons.edit_note_rounded, Color(0xFFE1D9F8)),
  revision('Revision', Icons.menu_book_rounded, Color(0xFFFFE8AC));

  const Subject(this.label, this.icon, this.color);
  final String label;
  final IconData icon;
  final Color color;
}

class StudyTask {
  StudyTask({
    required this.id,
    required this.title,
    required this.subject,
    required this.minutes,
    this.isDone = false,
  });

  final String id;
  final String title;
  final Subject subject;
  final int minutes;
  bool isDone;

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'subject': subject.name,
    'minutes': minutes,
    'isDone': isDone,
  };

  factory StudyTask.fromJson(Map<String, dynamic> json) => StudyTask(
    id: json['id'] as String,
    title: json['title'] as String,
    subject: Subject.values.byName(json['subject'] as String),
    minutes: json['minutes'] as int,
    isDone: json['isDone'] as bool,
  );
}

// One source of truth keeps the three screens in sync.
class Planner extends ChangeNotifier {
  final List<StudyTask> tasks = [];
  final SharedPreferencesAsync _preferences = SharedPreferencesAsync();
  Future<void> _pendingSave = Future.value();

  int get completedCount => tasks.where((task) => task.isDone).length;
  int get plannedMinutes => tasks.fold(0, (sum, task) => sum + task.minutes);
  int get finishedMinutes => tasks
      .where((task) => task.isDone)
      .fold(0, (sum, task) => sum + task.minutes);
  double get progress => tasks.isEmpty ? 0 : completedCount / tasks.length;

  Future<void> load() async {
    try {
      final saved = await _preferences.getString('aster_tasks');
      if (saved != null) {
        final data = jsonDecode(saved) as List<dynamic>;
        tasks.addAll(
          data.map(
            (item) =>
                StudyTask.fromJson(Map<String, dynamic>.from(item as Map)),
          ),
        );
      }
    } catch (_) {
      tasks.clear();
    }
    notifyListeners();
  }

  void addTask(String title, Subject subject, int minutes) {
    tasks.add(
      StudyTask(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        title: title.trim(),
        subject: subject,
        minutes: minutes,
      ),
    );
    notifyListeners();
    _save();
  }

  void toggleTask(StudyTask task) {
    task.isDone = !task.isDone;
    notifyListeners();
    _save();
  }

  void deleteTask(StudyTask task) {
    tasks.remove(task);
    notifyListeners();
    _save();
  }

  void _save() {
    final snapshot = jsonEncode(tasks.map((task) => task.toJson()).toList());
    _pendingSave = _pendingSave.then(
      (_) => _preferences.setString('aster_tasks', snapshot),
    );
  }
}
