import 'dart:collection';
import 'dart:math';

class Config {

  static const NUM_OF_QUESTIONS_FOR_IMAGE_UPLOAD_SESSION = 10;
  static const NUM_OF_QUESTIONS_FOR_SINGLE_LEVEL = 3;
  static const NUM_OF_SENTENCES_FOR_BASE_SINGLE_QUESTION = 1;
  static const NUM_OF_CORRECT_ANSWERS_FOR_NEXT_LEVEL = 3;
  static const NUM_OF_LEVELS = 10;

  static const POINTS_FOR_CORRECT_ANSWER = 3;
  static const POINTS_FOR_INCORRECT_ANSWER = -1;

}

//a single level in the game
class Level{
  final int level;
  final HashMap<int, bool> questions = HashMap();
  final DateTime start = DateTime.now();
  DateTime end = DateTime.now();

  Level(this.level);

  bool completed(){
    int correct = 0;
    for (int level in questions.keys) {
      if(questions[level]!) correct ++;
    }
    return correct >= Config.NUM_OF_CORRECT_ANSWERS_FOR_NEXT_LEVEL;
  }

  String time(){
    Duration difference = end.difference(start);
    int seconds = difference.inSeconds;
    int minutes = (seconds / 60).toInt();
    seconds -= minutes * 60;

    return "$minutes min $seconds seconds";

    //total time taken for the level
  }
  int seconds(){
    Duration difference = end.difference(start);
    return difference.inSeconds;
  }
}
//Manages game levels and scoring
class LevelGame{
  static HashMap<int, Level> score = HashMap();

  static bool isUnlocked(int level){

    if (level == 1) return true;  //// First level always unlocked
    if (level == -1) return true;
    if (score.containsKey(level)) return true;
    if (!score.containsKey(level - 1)) return false;

    Level prev = score[level - 1]!;

    return prev.completed();
  }
  static void addLevel(int level){
    if (isUnlocked(level)){
      score[level] = Level(level);
    }
  }
  static int getScore(int level){
    Level? l = score[level];
    if (l == null) return 0;

    int score_correct = 0;
    int score_incorrect = 0;
    for (int key in l.questions.keys) {
      if (l.questions[key]!) score_correct++;
      else score_incorrect ++;
    }

    return (score_correct * Config.POINTS_FOR_CORRECT_ANSWER) - (score_incorrect * Config.POINTS_FOR_INCORRECT_ANSWER);
  }

  static int getScorePercentage(int level){
    Level l = score[level]!;
    int score_correct = 0;


    //Count correct and incorrect answers
    for (int key in l.questions.keys) {
      if (l.questions[key]!) score_correct++;
    }
    return (score_correct * 100 / Config.NUM_OF_QUESTIONS_FOR_SINGLE_LEVEL).toInt();
  }

  static String getScoreText(int level){
    bool upload = level < 0;

    int mark = 0,time = 0;

    Level l = score[level]!;
    int score_correct = 0;
    for (int key in l.questions.keys) {
      if (l.questions[key]!) score_correct++;
    }

//Calculate marks as percentage
    int marks = (score_correct * 100 / (upload ? Config.NUM_OF_QUESTIONS_FOR_IMAGE_UPLOAD_SESSION : Config.NUM_OF_QUESTIONS_FOR_SINGLE_LEVEL)).toInt();

    List<String> x = ["Excellent", "Good", "Average", "Needs Improvement"];

    if (marks >= 90) mark++;
    if (marks >= 85) mark++;
    if (marks >= 70) mark++;


    if(!upload){
      int seconds = l.seconds();
      if (seconds <= 300) time++;
      if (seconds <= 450) time++;
      if (seconds <= 600) time++;

      return x[3 - min(mark, time)];
    }


    return x[3 - mark];
  }

//level update
}