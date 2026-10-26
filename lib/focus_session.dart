class FocusSession {
  const FocusSession({
    required this.taskTitle,
    required this.subjectName,
    required this.seconds,
    required this.completedAt,
  });

  final String taskTitle;
  final String subjectName;
  final int seconds;
  final DateTime completedAt;

  Map<String, dynamic> toJson() => {
    'taskTitle': taskTitle,
    'subjectName': subjectName,
    'seconds': seconds,
    'completedAt': completedAt.toIso8601String(),
  };

  factory FocusSession.fromJson(Map<String, dynamic> json) => FocusSession(
    taskTitle: json['taskTitle'] as String,
    subjectName: json['subjectName'] as String,
    seconds: json['seconds'] as int,
    completedAt: DateTime.parse(json['completedAt'] as String),
  );
}
