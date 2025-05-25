class PrepositionData {
  final String status;
  final int score;
  final String level;
  final String timeSpent;
  final String userId;

  PrepositionData({
    required this.status,
    required this.score,
    required this.level,
    required this.timeSpent,
    required this.userId,
  });

  factory PrepositionData.fromMap(Map<String, dynamic> map) {
    return PrepositionData(
      status: map['status'] ?? '',
      score: map['score'] ?? 0,
      level: map['level'] ?? '',
      timeSpent: map['time_spent'] ?? '',
      userId: map['user_id'] ?? '',
    );
  }
}
