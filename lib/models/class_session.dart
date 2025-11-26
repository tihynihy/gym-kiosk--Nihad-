class ClassSession {
  final String id;
  final String name;
  final DateTime startTime;
  final DateTime endTime;
  final String instructor;
  final String? description;
  final int capacity;

  ClassSession({
    required this.id,
    required this.name,
    required this.startTime,
    required this.endTime,
    required this.instructor,
    this.description,
    required this.capacity,
  });

  factory ClassSession.fromJson(Map<String, dynamic> json) {
    return ClassSession(
      id: json['id'] as String,
      name: json['name'] as String,
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: DateTime.parse(json['endTime'] as String),
      instructor: json['instructor'] as String,
      description: json['description'] as String?,
      capacity: json['capacity'] as int,
    );
  }

  String get timeRange {
    final start = '${startTime.hour.toString().padLeft(2, '0')}:${startTime.minute.toString().padLeft(2, '0')}';
    final end = '${endTime.hour.toString().padLeft(2, '0')}:${endTime.minute.toString().padLeft(2, '0')}';
    return '$start - $end';
  }

  bool get isToday {
    final now = DateTime.now();
    return startTime.year == now.year &&
        startTime.month == now.month &&
        startTime.day == now.day;
  }
}