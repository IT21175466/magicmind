class PuzzleResult {
  String user_id;
  String id;
  String age;
  String gender;
  String difficultyLevel;
  int timeTaken;
  int correctMoves;
  int incorrectMoves;
  int hintsUsed;
  int splitAmount;
  int score;
  String nvldSeverity;
  String physicalActivity;
  String sleepHours;
  String nvldDiagnosis;
  int level;
  DateTime date;

  PuzzleResult({
    required this.user_id,
    required this.id,
    required this.age,
    required this.gender,
    required this.difficultyLevel,
    required this.timeTaken,
    required this.correctMoves,
    required this.incorrectMoves,
    required this.hintsUsed,
    required this.splitAmount,
    required this.score,
    required this.nvldSeverity,
    required this.physicalActivity,
    required this.sleepHours,
    required this.nvldDiagnosis,
    required this.level,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'user_id': user_id,
      'id': id,
      'age': age,
      'gender': gender,
      'difficultyLevel': difficultyLevel,
      'timeTaken': timeTaken,
      'correctMoves': correctMoves,
      'incorrectMoves': incorrectMoves,
      'hintsUsed': hintsUsed,
      'splitAmount': splitAmount,
      'score': score,
      'nvldSeverity': nvldSeverity,
      'physicalActivity': physicalActivity,
      'sleepHours': sleepHours,
      'nvldDiagnosis': nvldDiagnosis,
      'level': level,
      'date': DateTime.now(),
    };
  }

  factory PuzzleResult.fromMap(Map<String, dynamic> map) {
    return PuzzleResult(
      user_id: map['user_id'],
      id: map['id'],
      age: map['age'],
      gender: map['gender'],
      difficultyLevel: map['difficultyLevel'],
      timeTaken: map['timeTaken'],
      correctMoves: map['correctMoves'],
      incorrectMoves: map['incorrectMoves'],
      hintsUsed: map['hintsUsed'],
      splitAmount: map['splitAmount'],
      score: map['score'],
      nvldSeverity: map['nvldSeverity'],
      physicalActivity: map['physicalActivity'],
      sleepHours: map['sleepHours'],
      nvldDiagnosis: map['nvldDiagnosis'],
      level: map['level'],
      date: map['date'],
    );
  }
}
