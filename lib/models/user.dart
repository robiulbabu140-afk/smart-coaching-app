class User {
  final String id;
  final String phone;
  final String fullName;
  final String role;
  final String status;

  User({
    required this.id,
    required this.phone,
    required this.fullName,
    required this.role,
    required this.status,
  });

  factory User.fromJson(Map<String, dynamic> j) => User(
        id: j['id'] ?? '',
        phone: j['phone'] ?? '',
        fullName: j['fullName'] ?? '',
        role: j['role'] ?? '',
        status: j['status'] ?? '',
      );
}

class Batch {
  final String id;
  final String name;
  final String? subject;
  final List<String> scheduleDays;
  final String? scheduleTime;
  final String? status;
  final Map<String, dynamic>? teacher;
  final int memberCount;

  Batch({
    required this.id,
    required this.name,
    this.subject,
    required this.scheduleDays,
    this.scheduleTime,
    this.status,
    this.teacher,
    this.memberCount = 0,
  });

  factory Batch.fromJson(Map<String, dynamic> j) => Batch(
        id: j['id'] ?? '',
        name: j['name'] ?? '',
        subject: j['subject'],
        scheduleDays: List<String>.from(j['scheduleDays'] ?? []),
        scheduleTime: j['scheduleTime'],
        status: j['status'],
        teacher: j['teacher'],
        memberCount: j['_count']?['members'] ?? 0,
      );
}
