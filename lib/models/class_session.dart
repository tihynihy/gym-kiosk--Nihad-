class ClassSession {
  final String id;
  final String name;
  final DateTime startTime;
  final DateTime endTime;
  final String instructor;
  final String? instructorShortName;
  final String? instructorProfilePicture;
  final String? description;
  final int capacity;
  final List<String> tags;

  ClassSession({
    required this.id,
    required this.name,
    required this.startTime,
    required this.endTime,
    required this.instructor,
    this.instructorShortName,
    this.instructorProfilePicture,
    this.description,
    required this.capacity,
    this.tags = const [],
  });

  factory ClassSession.fromJson(Map<String, dynamic> json) {
    return ClassSession(
      id: json['id'] as String,
      name: json['name'] as String,
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: DateTime.parse(json['endTime'] as String),
      instructor: json['instructor'] as String,
      instructorShortName: json['instructorShortName'] as String?,
      instructorProfilePicture: json['instructorProfilePicture'] as String?,
      description: json['description'] as String?,
      capacity: json['capacity'] as int,
      tags: json['tags'] != null 
          ? List<String>.from(json['tags'] as List)
          : [],
    );
  }

  String get timeRange {
    final start = '${startTime.hour.toString().padLeft(2, '0')}:${startTime.minute.toString().padLeft(2, '0')}';
    final end = '${endTime.hour.toString().padLeft(2, '0')}:${endTime.minute.toString().padLeft(2, '0')}';
    return '$start - $end';
  }

  String get timeRangeWithH {
    return '${timeRange}h';
  }

  bool get isToday {
    final now = DateTime.now();
    return startTime.year == now.year &&
        startTime.month == now.month &&
        startTime.day == now.day;
  }
}