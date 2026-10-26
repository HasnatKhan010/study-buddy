import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'focus_session.dart';

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
    this.notes = '',
    this.dueDate,
    this.isDone = false,
    int? remainingSeconds,
    this.endsAt,
  }) : remainingSeconds = remainingSeconds ?? minutes * 60;

  final String id;
  String title;
  Subject subject;
  int minutes;
  String notes;
  DateTime? dueDate;
  bool isDone;
  int remainingSeconds;
  DateTime? endsAt;

  int get secondsLeft {
    if (endsAt == null) return remainingSeconds;
    final milliseconds = endsAt!.difference(DateTime.now()).inMilliseconds;
    if (milliseconds <= 0) return 0;
    return (milliseconds / 1000).ceil();
  }

  bool get isRunning => endsAt != null && secondsLeft > 0;

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'subject': subject.name,
    'minutes': minutes,
    'notes': notes,
    'dueDate': dueDate?.toIso8601String(),
    'isDone': isDone,
    'remainingSeconds': remainingSeconds,
    'endsAt': endsAt?.toIso8601String(),
  };

  factory StudyTask.fromJson(Map<String, dynamic> json) => StudyTask(
    id: json['id'] as String,
    title: json['title'] as String,
    subject: Subject.values.byName(json['subject'] as String),
    minutes: json['minutes'] as int,
    notes: json['notes'] as String? ?? '',
    dueDate: json['dueDate'] == null
        ? null
        : DateTime.tryParse(json['dueDate'] as String),
    isDone: json['isDone'] as bool,
    remainingSeconds: json['remainingSeconds'] as int?,
    endsAt: json['endsAt'] == null
        ? null
        : DateTime.tryParse(json['endsAt'] as String),
  );
}

// One source of truth keeps the three screens in sync.
class Planner extends ChangeNotifier {
  final List<StudyTask> tasks = [];
  final List<FocusSession> sessions = [];
  final SharedPreferencesAsync _preferences = SharedPreferencesAsync();
  Future<void> _pendingSave = Future.value();
  Timer? _ticker;
  final List<String> _alerts = [];
  bool soundEnabled = true;
  int dailyGoalMinutes = 60;

  int get completedCount => tasks.where((task) => task.isDone).length;
  int get plannedMinutes => tasks.fold(0, (sum, task) => sum + task.minutes);
  int get finishedMinutes => tasks
      .where((task) => task.isDone)
      .fold(0, (sum, task) => sum + task.minutes);
  double get progress => tasks.isEmpty ? 0 : completedCount / tasks.length;
  int get focusSecondsToday {
    final today = DateTime.now();
    return sessions
        .where((session) {
          final day = session.completedAt.toLocal();
          return day.year == today.year &&
              day.month == today.month &&
              day.day == today.day;
        })
        .fold(0, (total, session) => total + session.seconds);
  }

  bool get hasAlerts => _alerts.isNotEmpty;
  String? takeAlert() => _alerts.isEmpty ? null : _alerts.removeAt(0);

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
      final savedSessions = await _preferences.getString(
        'study_buddy_sessions',
      );
      if (savedSessions != null) {
        final data = jsonDecode(savedSessions) as List<dynamic>;
        sessions.addAll(
          data.map(
            (item) =>
                FocusSession.fromJson(Map<String, dynamic>.from(item as Map)),
          ),
        );
      }
      soundEnabled =
          await _preferences.getBool('study_buddy_sound_enabled') ?? true;
      dailyGoalMinutes =
          await _preferences.getInt('study_buddy_daily_goal') ?? 60;
    } catch (_) {
      tasks.clear();
      sessions.clear();
    }
    _finishExpiredTimers();
    _startTickerIfNeeded();
    notifyListeners();
  }

  void addTask(
    String title,
    Subject subject,
    int minutes, {
    String notes = '',
    DateTime? dueDate,
  }) {
    tasks.add(
      StudyTask(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        title: title.trim(),
        subject: subject,
        minutes: minutes,
        notes: notes.trim(),
        dueDate: dueDate,
      ),
    );
    notifyListeners();
    _save();
  }

  void updateTask(
    StudyTask task,
    String title,
    Subject subject,
    int minutes, {
    String notes = '',
    DateTime? dueDate,
  }) {
    if (task.minutes != minutes) {
      task.minutes = minutes;
      task.endsAt = null;
      task.remainingSeconds = task.isDone ? 0 : minutes * 60;
      _stopTickerIfIdle();
    }
    task.title = title.trim();
    task.subject = subject;
    task.notes = notes.trim();
    task.dueDate = dueDate;
    notifyListeners();
    _save();
  }

  void toggleTask(StudyTask task) {
    if (!task.isDone) {
      finishTask(task);
      return;
    }
    task.isDone = false;
    task.endsAt = null;
    task.remainingSeconds = task.minutes * 60;
    _stopTickerIfIdle();
    notifyListeners();
    _save();
  }

  void startTimer(StudyTask task) {
    if (task.isDone || task.isRunning) return;
    if (task.remainingSeconds == 0) task.remainingSeconds = task.minutes * 60;
    task.endsAt = DateTime.now().toUtc().add(
      Duration(seconds: task.remainingSeconds),
    );
    _startTickerIfNeeded();
    notifyListeners();
    _save();
  }

  void pauseTimer(StudyTask task) {
    if (task.endsAt == null) return;
    task.remainingSeconds = task.secondsLeft;
    task.endsAt = null;
    _stopTickerIfIdle();
    notifyListeners();
    _save();
  }

  void resetTimer(StudyTask task) {
    task.endsAt = null;
    task.remainingSeconds = task.minutes * 60;
    _stopTickerIfIdle();
    notifyListeners();
    _save();
  }

  void finishTask(StudyTask task) {
    if (!task.isDone && (task.endsAt != null || task.remainingSeconds > 0)) {
      final focusedSeconds = task.minutes * 60 - task.secondsLeft;
      if (focusedSeconds > 0) {
        _recordSession(task, focusedSeconds, DateTime.now());
      }
    }
    task.endsAt = null;
    task.remainingSeconds = 0;
    task.isDone = true;
    _stopTickerIfIdle();
    notifyListeners();
    _save();
  }

  void deleteTask(StudyTask task) {
    tasks.remove(task);
    _stopTickerIfIdle();
    notifyListeners();
    _save();
  }

  void setSoundEnabled(bool enabled) {
    soundEnabled = enabled;
    notifyListeners();
    _save();
  }

  void setDailyGoal(int minutes) {
    dailyGoalMinutes = minutes;
    notifyListeners();
    _save();
  }

  void checkTimers() {
    _finishExpiredTimers();
    _startTickerIfNeeded();
    notifyListeners();
  }

  void _recordSession(StudyTask task, int seconds, DateTime completedAt) {
    sessions.insert(
      0,
      FocusSession(
        taskTitle: task.title,
        subjectName: task.subject.label,
        seconds: seconds,
        completedAt: completedAt,
      ),
    );
    if (sessions.length > 200) sessions.removeLast();
  }

  void _finishExpiredTimers() {
    var changed = false;
    for (final task in tasks) {
      if (task.endsAt != null && task.secondsLeft == 0) {
        _recordSession(task, task.minutes * 60, task.endsAt!);
        _alerts.add('Focus session complete: ${task.title}');
        task.endsAt = null;
        task.remainingSeconds = 0;
        changed = true;
      }
    }
    if (changed) _save();
  }

  void _startTickerIfNeeded() {
    if (_ticker != null || !tasks.any((task) => task.endsAt != null)) return;
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      _finishExpiredTimers();
      _stopTickerIfIdle();
      notifyListeners();
    });
  }

  void _stopTickerIfIdle() {
    if (tasks.any((task) => task.endsAt != null)) return;
    _ticker?.cancel();
    _ticker = null;
  }

  void _save() {
    final taskSnapshot = jsonEncode(
      tasks.map((task) => task.toJson()).toList(),
    );
    final sessionSnapshot = jsonEncode(
      sessions.map((session) => session.toJson()).toList(),
    );
    final savedSound = soundEnabled;
    final savedGoal = dailyGoalMinutes;
    _pendingSave = _pendingSave.then((_) async {
      await _preferences.setString('aster_tasks', taskSnapshot);
      await _preferences.setString('study_buddy_sessions', sessionSnapshot);
      await _preferences.setBool('study_buddy_sound_enabled', savedSound);
      await _preferences.setInt('study_buddy_daily_goal', savedGoal);
    });
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }
}
