class CheckIn {
  final String id;
  final String memberId;
  final String classSessionId;
  final DateTime timestamp;
  final CheckInStatus status;

  CheckIn({
    required this.id,
    required this.memberId,
    required this.classSessionId,
    required this.timestamp,
    this.status = CheckInStatus.confirmed,
  });

  factory CheckIn.fromJson(Map<String, dynamic> json) {
    return CheckIn(
      id: json['id'] as String,
      memberId: json['memberId'] as String,
      classSessionId: json['classSessionId'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      status: CheckInStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
        orElse: () => CheckInStatus.confirmed,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'memberId': memberId,
      'classSessionId': classSessionId,
      'timestamp': timestamp.toIso8601String(),
      'status': status.toString().split('.').last,
    };
  }
}

enum CheckInStatus {
  confirmed,
  registered,
  waitlisted,
}