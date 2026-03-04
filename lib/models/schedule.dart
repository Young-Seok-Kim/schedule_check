class Schedule {
  final String title;
  final String content;
  final DateTime date;

  Schedule({required this.title, required this.content, required this.date});

  // Hive 저장용 Map 변환
  Map<String, dynamic> toMap() => {
    'title': title,
    'content': content,
    'date': date.toIso8601String(),
  };

  // Hive 로드용 객체 변환
  factory Schedule.fromMap(Map<dynamic, dynamic> map) => Schedule(
    title: map['title'],
    content: map['content'],
    date: DateTime.parse(map['date']),
  );
}

// 기존 WorkStatus는 유지...