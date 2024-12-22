class PuzzleResult {
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

  PuzzleResult({
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
  });

  Map<String, dynamic> toMap() {
    return {
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
    };
  }
}
