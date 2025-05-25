import 'dart:developer';

import 'package:magicmind_puzzle/constants/constant.dart';
import 'package:magicmind_puzzle/models/puzzle_result_model.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:uuid/uuid.dart';

class MongoDatabase {
  static connect() async {
    var db = await Db.create(MONGO_URL);
    await db.open();
    inspect(db);

    var status = db.serverStatus();
    print(status);

    var collection = db.collection(COLLECTION_NAME);
    print(await collection.find().toList());
  }

  static Future<void> insertPrepositionData(String status, int score,
      String level, String time, String user_id) async {
    var db = await Db.create(MONGO_URL);
    await db.open();
    var collection = db.collection('Preposition');

    await collection.insertOne({
      'status': status,
      'score': score,
      'level': level,
      'time_spent': time,
      'user_id': user_id
    });
    print('Preposition Data inserted successfully');
  }

  static Future<void> insertData({
    required String difficultyLevel,
    required String user_id,
    required int timeElapsed,
    required int movesMade,
    required int incorrectMoves,
    required int hintUsed,
    required int score,
    required int level,
  }) async {
    var db = await Db.create(MONGO_URL);
    await db.open();
    var collection = db.collection(COLLECTION_NAME);

    var puzzleResult = PuzzleResult(
      id: Uuid().v4(),
      age: 'NaN',
      gender: 'NaN',
      difficultyLevel: difficultyLevel,
      timeTaken: timeElapsed,
      correctMoves: movesMade,
      incorrectMoves: incorrectMoves,
      hintsUsed: hintUsed,
      splitAmount: movesMade,
      score: score,
      nvldSeverity: 'NaN',
      physicalActivity: 'NaN',
      sleepHours: 'NaN',
      nvldDiagnosis: 'NaN',
      level: level,
      date: DateTime.now(),
      user_id: user_id,
    );

    await collection.insertOne(puzzleResult.toMap());
    print('Data inserted successfully');
  }

  static Future<List<PuzzleResult>> getData(String user_id) async {
    try {
      var db = await Db.create(MONGO_URL);
      await db.open();

      var collection = db.collection(COLLECTION_NAME);
      List<Map<String, dynamic>> data = await collection.find().toList();

      List<PuzzleResult> results =
          data.map((map) => PuzzleResult.fromMap(map)).toList();

      await db.close();
      return results;
    } catch (e) {
      print("Error retrieving data: $e");
      return [];
    }
  }
}
