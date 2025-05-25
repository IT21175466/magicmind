import 'dart:collection';
import 'dart:math';
import 'dart:math' as Math;
import 'package:csv/csv.dart';
import 'package:flutter/services.dart';
import 'package:magicmind_puzzle/preposition_feature/function.dart';
import 'package:magicmind_puzzle/preposition_feature/score.dart';

const Map<String, List<String>> ANSWERS = {
  "above": ["in", "below", "under", "between"],
  "on": ["in", "below", "under", "between"],
  "between": ["in", "below", "under", "above"],
  "below": ["in", "above", "on", "between"],
  "under": ["in", "above", "on", "between"],
  "near": ["in", "behind", "at", "between"],
  "next to": ["in", "behind", "at", "between"],
  "beside": ["behind", "near", "under", "on"],
  "behind": ["in front of", "above", "below", "between"],
  "in front of": ["behind", "above", "under", "on"],
  "inside": ["outside", "above", "on", "below"],
  "outside": ["inside", "under", "on", "between"],
  "over": ["under", "between", "next to", "on"],
  "across": ["along", "beside", "near", "under"],
  "along": ["across", "between", "beside", "on"],
  "towards": ["away from", "under", "above", "on"],
  "away from": ["towards", "near", "on", "under"],
  "at": ["on", "in", "under", "between"],
  "right to": ["left to", "behind", "in front of", "on"],
  "left to": ["right to", "near", "on", "under"],
  "top to": ["bottom to", "above", "on", "under"],
  "bottom to": ["top to", "under", "below", "on"],
  "right of": ["left of", "next to", "beside", "between"],
  "left of": ["right of", "near", "on", "under"],
  "on top of": ["under", "below", "next to", "between"],
  "partially covering": ["covering", "partially covered by", "around", "on"],
  "covering": ["partially covering", "partially covered by", "over", "on"],
  "partially covered by": ["covering", "partially covering", "under", "below"],
  "around": ["near", "beside", "next to", "between"],
  "left": ["right", "next to", "beside", "near"],
  "right": ["left", "next to", "beside", "near"],
};

const List<String> TEMPLATES = [
  "V|2|The >1< is >above< the >2<",
  "V|2|The >1< is >on< the >2<",
  "V|2|The >2< is >below< the >1<",
  "V|2|The >2< is >under< the >1<",
  "H|3|The >2< is >between< the >1< and the >3<",
  "V|3|The >2< is >between< the >1< and the >3<",
  "H|2|The >2< is >near< the >1<",
  "V|2|The >1< is >near< the >2<",
  "H|2|The >2< is >next to< the >1<",
  "V|2|The >1< is >next to< the >2<",
];

class Sentence {
  final String pre, post, answer;
  final List<String> answers;

  List<String>? icons;

  String? userAnswer;

  Sentence(
      {required this.pre,
      required this.post,
      required this.answer,
      required this.answers});
}

Future<List<HashMap<String, String>>> readQuestions() async {
  String text =
      await rootBundle.loadString('assets/question/preposition_questions.csv');
  List<List<String>> data = CsvToListConverter(shouldParseNumbers: false)
      .convert(text, eol: "\n", shouldParseNumbers: false);
  List<String> columns = data[0];

  List<HashMap<String, String>> out = [];
  for (int i = 1; i < data.length; i++) {
    HashMap<String, String> row = HashMap();

    for (int j = 0; j < columns.length; j++) {
      row[columns[j]] = data[i][j];
    }
    out.add(row);
  }

  return out;
}

Future<List<int>> getImages(int level) async {
  String text =
      await rootBundle.loadString('assets/question/preposition_questions.csv');
  List<List<String>> data = CsvToListConverter(shouldParseNumbers: false)
      .convert(text, eol: "\n", shouldParseNumbers: false);
  List<String> columns = data[0];

  List<int> out = [];
  for (int i = 1; i < data.length; i++) {
    HashMap<String, String> row = HashMap();

    for (int j = 0; j < columns.length; j++) {
      row[columns[j]] = data[i][j];
    }

    int image = int.parse(row['Image']!.split(".")[0]);
    int start = int.parse(row['Start']!);
    int end = int.parse(row['End']!);

    if (start <= level && end >= level) {
      if (!out.contains(image)) out.add(image);
    }
  }

  return out;
}

Sentence generateSingleSentence(String template, List<String> icons) {
  for (int i = 0; i < icons.length; i++) {
    String icon = icons[i].split(".")[0];
    template = template.replaceAll(">${i + 1}<", icon);
  }

  List<String> x = template.split(">");
  List<String> y = x[1].split("<");

  Sentence sentence = Sentence(
      pre: x[0], post: y[1], answer: y[0], answers: generateAnswers(y[0]));
  sentence.icons = icons;

  return sentence;
}

List<String> generateAnswers(String answer) {
  List<String> answers = [];

  final random = Random();

  int i = 0;

  List<String> all = ANSWERS[answer] ?? ['a1', 'a2', 'a3', 'a4'];
  while (i < 3) {
    int index = random.nextInt(all.length);
    String ans = all[index];

    if (!answers.contains(ans)) {
      answers.add(ans);
      i++;
    }
  }

  int index = random.nextInt(4);
  answers.insert(index, answer);

  return answers;
}

class Relationship {
  final IdentifiedObject objectA, objectB;
  final String relationship;
  double? accuracy;
  Relationship(
      {required this.objectA,
      required this.objectB,
      required this.relationship});
}

//bug fixed
List<Sentence> generateSentencesNew(List<IdentifiedObject> objects, int level) {
  List<Sentence> sentences = [];

  List<Relationship> relationships = [];
  List<Relationship> nears = [];

  for (IdentifiedObject a in objects) {
    for (IdentifiedObject b in objects) {
      if (a.label == b.label) continue;

      String? code;
      if (a.x2 < b.x1) {
        code = 'left';
      } else if (a.x1 > b.x2) {
        code = 'right';
      } else if (a.y2 < b.y1) {
        code = 'up';
      } else if (a.y1 > b.y2) {
        code = 'down';
      } else if (a.x1 < b.x1 || a.x2 > b.x2 || a.y1 < b.y1 || a.y2 > b.y2) {
        code = 'near';
        nears.add(Relationship(objectA: a, objectB: b, relationship: code));
        continue;
      }

      if (code != null) {
        relationships
            .add(Relationship(objectA: a, objectB: b, relationship: code));
      }
    }
  }

  for (String line in TEMPLATES) {
    var [orientation, icon_count, template] = line.split("|");

    if (icon_count != "2") continue;

    for (Relationship relationship in relationships) {
      if (['up', 'down'].contains(relationship.relationship) &&
          orientation == "H") continue;

      IdentifiedObject a, b;
      if (['left', 'up'].contains(relationship.relationship)) {
        a = relationship.objectA;
        b = relationship.objectB;
      } else {
        b = relationship.objectA;
        a = relationship.objectB;
      }

      if (relationship.relationship == "near") {
        sentences.add(generateSingleSentence(
            "The >2< is >near< the >1<", [a.label, b.label]));
      } else {
        sentences.add(generateSingleSentence(template, [a.label, b.label]));
      }
    }
  }

  int count = level;
  List<Sentence> out = [];

  int i = 0;
  Random random = Random();

  int z = 0;
  while (i < count) {
    int index = random.nextInt(sentences.length);
    Sentence sentence = sentences[index];

    if (!out.contains(sentence)) {
      out.add(sentence);
      i++;
    }

    z++;
    if (z > 1000) break;
  }

  return out;
}

List<Relationship> identifyRelationships(
    List<IdentifiedObject> objects, int level) {
  String calculateSpatialRelationship(IdentifiedObject a, IdentifiedObject b) {
    // OL Object A and Object B has an overlap. Overlap is mostly to the left to the Object A
    // OR Object A and Object B has an overlap. Overlap is mostly to the right to the Object A
    // OT Object A and Object B has an overlap. Overlap is mostly to the top to the Object A
    // OB Object A and Object B has an overlap. Overlap is mostly to the bottom to the Object A

    bool noOverlap =
        (b.x1 > a.x2) || (b.x2 < a.x1) || (b.y1 > a.y2) || (b.y2 < a.y1);

    if (noOverlap) {
      // L Object B is left to the Object A
      // R Object B is right to the Object A
      // T Object B is top to the Object A
      // B Object B is bottom to the Object A

      double ax = (a.x1 + a.x2) / 2;
      double ay = (a.y1 + a.y2) / 2;
      double bx = (b.x1 + b.x2) / 2;
      double by = (b.y1 + b.y2) / 2;

      if (bx < ax) {
        return "L";
      } else if (bx > ax) {
        return "R";
      } else if (by < ay) {
        return "T";
      } else if (by > ay) {
        return "B";
      }

      return "O";
    }

    // O Object A is inside the Object B
    if ((b.x1 <= a.x1) && (b.x2 >= a.x2) && (b.y1 <= a.y1) && (b.y2 >= a.y2))
      return "O";
    // I Object B is inside the Object A
    if ((a.x1 <= b.x1) && (a.x2 >= b.x2) && (a.y1 <= b.y1) && (a.y2 >= b.y2))
      return "I";

    //Overlap

    int x = min(a.x2, b.x2) - max(a.x1, b.x1);
    int y = min(a.y2, b.y2) - max(a.y1, b.y1);

    double ax = (a.x1 + a.x2) / 2;
    double ay = (a.y1 + a.y2) / 2;
    double bx = (b.x1 + b.x2) / 2;
    double by = (b.y1 + b.y2) / 2;

    double dx = bx - ax;
    double dy = by - ay;

    if (dx.abs() > dy.abs()) {
      if (dx > 0) {
        return "OR";
      } else {
        return "OL";
      }
    } else {
      if (dy > 0) {
        return "OB";
      } else {
        return "OT";
      }
    }
    return "OX: $x $y";
  }

  List<Relationship> relationships = [];

  for (IdentifiedObject a in objects) {
    for (IdentifiedObject b in objects) {
      if (a.label == b.label) continue;

      String code = calculateSpatialRelationship(a, b);
      Relationship relationship =
          Relationship(objectA: a, objectB: b, relationship: code);
      relationship.accuracy = (a.accuracy ?? 0) * (b.accuracy ?? 0);
      relationships.add(relationship);
    }
  }

  return relationships;
}

Future<List<Sentence>> generateSentencesX(String img, int level) async {
  List<Sentence> sentences = [];

  List<HashMap<String, String>> questions = await readQuestions();

  // Image,Pre,Answer,Post,Answers,Start,End

  for (HashMap<String, String> q in questions) {
    if (q['Image'] != img) continue;

    Sentence sentence = Sentence(
        pre: q['Pre']!,
        post: q['Post']!,
        answer: q['Answer']!,
        answers: q['Answers']!.split(","));

    int start = int.parse(q['Start']!);
    int end = int.parse(q['End']!);

    if (start <= level && end >= level) {
      sentences.add(sentence);
    } else {
      // //TODO: Remove
      // sentences.add(sentence);
    }
  }

  int count = level + Config.NUM_OF_SENTENCES_FOR_BASE_SINGLE_QUESTION - 1;
  List<Sentence> out = [];

  if (sentences.length <= count) return sentences;

  int i = 0;
  Random random = Random();

  while (i < count) {
    int index = random.nextInt(sentences.length);
    Sentence sentence = sentences[index];

    if (!out.contains(sentence)) {
      out.add(sentence);
      i++;
    }
  }

  return out;
}

Future<List<Sentence>> generateSentencesY(String img, int level) async {
  List<Sentence> sentences = [];

  List<HashMap<String, String>> questions = await readQuestions();

  // Image,Pre,Answer,Post,Answers,Start,End

  for (HashMap<String, String> q in questions) {
    if (q['Image'] != img) continue;

    Sentence sentence = Sentence(
        pre: q['Pre']!,
        post: q['Post']!,
        answer: q['Answer']!,
        answers: q['Answers']!.split(","));

    int start = int.parse(q['Start']!);
    int end = int.parse(q['End']!);

    if (start <= level && end >= level) {
      sentences.add(sentence);
    } else {
      // //TODO: Remove
      // sentences.add(sentence);
    }
  }

  int count = level + Config.NUM_OF_SENTENCES_FOR_BASE_SINGLE_QUESTION - 1;
  List<Sentence> out = [];

  if (sentences.length <= count) return sentences;

  int i = 0;
  Random random = Random();

  while (i < count) {
    int index = random.nextInt(sentences.length);
    Sentence sentence = sentences[index];

    if (!out.contains(sentence)) {
      out.add(sentence);
      i++;
    }
  }

  return out;
}
