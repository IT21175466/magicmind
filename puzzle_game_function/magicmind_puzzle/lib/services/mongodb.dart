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

  static Future<void> insertData({
    required String difficultyLevel,
    required int timeElapsed,
    required int movesMade,
    required int incorrectMoves,
    required int hintUsed,
    required int score,
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
    );

    await collection.insertOne(puzzleResult.toMap());
    print('Data inserted successfully');
  }
}
