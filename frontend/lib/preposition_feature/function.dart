import 'dart:async';
import 'dart:collection';
import 'dart:io';
import 'dart:math';

import 'package:csv/csv.dart';
import 'package:flutter/material.dart';

import 'dart:ui' as ui;
import 'package:flutter/services.dart' show Uint8List, rootBundle;
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';
import 'package:magicmind_puzzle/preposition_feature/question.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;

class GeneratedQuestion {
  final List<Sentence> sentences;
  final ui.Image image;
  final List<String> choices;

  static const int size = 640;

  const GeneratedQuestion(this.sentences, this.image, this.choices);

  static Future<GeneratedQuestion> create(int level) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    canvas.translate(0, 0);
    canvas.scale(1, 1);

    canvas.drawColor(Colors.amberAccent, BlendMode.overlay);
    List<int> images = await getImages(level);
    int img_ = images[Random().nextInt(images.length)];
    List<Sentence> sentences = [];
    sentences = await generateSentencesX("$img_.png", level);

    final ByteData data = await rootBundle.load("assets/question/$img_.png");
    ui.Image image = await convertImageToUiImage(
        img.decodeImage(data.buffer.asUint8List())!);

    return GeneratedQuestion(sentences, image, []);
  }

  static Future<GeneratedQuestion?> createUsingImage(XFile image) async {
    img.Image image_ = GeneratedQuestion.readImage(image);
    List<IdentifiedObject> objects =
        await GeneratedQuestion.detectObjects(image_);

    objects.sort((IdentifiedObject a, IdentifiedObject b) {
      return b.accuracy!.compareTo(a.accuracy!);
    });

    if (objects.length < 2) {
      return null;
    }

    List<Relationship> relationships =
        identifyRelationships(objects.sublist(0, 2), 1);

    String text = await rootBundle.loadString('assets/upload_image.csv');
    List<List<String>> data = CsvToListConverter(shouldParseNumbers: false)
        .convert(text, eol: "\r\n", shouldParseNumbers: false);

    List<Sentence> sentences = [];

    List<String> columns = data[0];

    for (int i = 1; i < data.length; i++) {
      HashMap<String, String> row = HashMap();

      for (int j = 0; j < columns.length; j++) {
        row[columns[j]] = data[i][j];
      }

      for (Relationship relationship in relationships) {
        if (relationship.relationship != row['code']) continue;
        if (relationship.objectA.label != row['a']) continue;
        if (relationship.objectB.label != row['b']) continue;

        sentences.add(Sentence(
            pre: row['pre']!,
            post: row['post']!,
            answer: row['preposition']!,
            answers: generateAnswers(row['preposition']!)));
      }
    }

    if (sentences.length < 2) {
      return null;
    }

    GeneratedQuestion create = await GeneratedQuestion.create(1);

    ui.Image image_x = await GeneratedQuestion.drawObjects(objects, image_,
        accuracy: min(objects[0].accuracy!, objects[1].accuracy!));
    return GeneratedQuestion([sentences[Random().nextInt(sentences.length)]],
        image_x, create.choices);
  }

  static const double THRESHOLD = 0.4;

  static Future<List<IdentifiedObject>> detectObjects(img.Image image) async {
    const String _modelPath = 'assets/tf/model.tflite';
    const String _labelPath = 'assets/tf/labels.txt';

    Interpreter? _interpreter;
    List<String>? _labels;

    final interpreterOptions = InterpreterOptions();
    if (Platform.isAndroid) {
      interpreterOptions.addDelegate(XNNPackDelegate());
    }

    _interpreter =
        await Interpreter.fromAsset(_modelPath, options: interpreterOptions);

    final labelsRaw = await rootBundle.loadString(_labelPath);
    _labels = labelsRaw.split('\n');

    final imageMatrix = List.generate(
      image.height,
      (y) => List.generate(
        image.width,
        (x) {
          final pixel = image.getPixel(x, y);
          return [pixel.r, pixel.g, pixel.b];
        },
      ),
    );

    final input = [imageMatrix];
    final output_ = {
      0: [List<List<num>>.filled(10, List<num>.filled(4, 0))],
      1: [List<num>.filled(10, 0)],
      2: [List<num>.filled(10, 0)],
      3: [0.0],
    };

    _interpreter.runForMultipleInputs([input], output_);
    final output = output_.values.toList();

    // Location
    final locationsRaw = output.first.first as List<List<double>>;
    final locations = locationsRaw.map((list) {
      return list.map((value) => (value * 300).toInt()).toList();
    }).toList();

    // Classes
    final classesRaw = output.elementAt(1).first as List<double>;
    final classes = classesRaw.map((value) => value.toInt()).toList();

    // Scores
    final scores = output.elementAt(2).first as List<double>;

    // Number of detections
    final numberOfDetectionsRaw = output.last.first as double;
    final numberOfDetections = numberOfDetectionsRaw.toInt();

    List<IdentifiedObject> objects = [];

    preprocess(a) {
      if (a < 0) return 0;
      if (a > 300) return 300;
      return a;
    }

    for (var i = 0; i < numberOfDetections; i++) {
      if (scores[i] > THRESHOLD) {}

      int x1 = preprocess(locations[i][1]);
      int y1 = preprocess(locations[i][0]);
      int x2 = preprocess(locations[i][3]);
      int y2 = preprocess(locations[i][2]);

      String label = _labels[classes[i]];
      IdentifiedObject object = IdentifiedObject(x1, x2, y1, y2, label);
      object.accuracy = scores[i];

      objects.add(object);
    }

    return objects;
  }

  static img.Image readImage(XFile image) {
    final imageData = File(image.path).readAsBytesSync();

    final image_ = img.decodeImage(imageData);
    final img.Image imageInput = img.copyResize(
      image_!,
      width: 300,
      height: 300,
    );
    return imageInput;
  }

  static Future<ui.Image> drawObjects(
      List<IdentifiedObject> objects, img.Image image,
      {double accuracy = 0.5}) async {
    for (var i = 0; i < objects.length; i++) {
      IdentifiedObject object = objects[i];

      if (object.accuracy! > accuracy) {
        img.drawRect(
          image,
          x1: object.x1,
          y1: object.y1,
          x2: object.x2,
          y2: object.y2,
          color: img.ColorRgb8(255, 0, 0),
          thickness: 3,
        );

        img.drawString(
          image,
          '${object.label} ${object.accuracy}',
          font: img.arial14,
          x: object.x1 + 1,
          y: object.y1 + 1,
          color: img.ColorRgb8(255, 0, 0),
        );
      }
    }

    return await convertImageToUiImage(image);
  }

  static Future<ui.Image> convertImageToUiImage(img.Image image) async {
    List<int> byteData = img.encodePng(image);
    final Completer<ui.Image> completer = Completer();
    ui.decodeImageFromList(Uint8List.fromList(byteData), (ui.Image img) {
      completer.complete(img);
    });
    return completer.future;
  }
}

class IdentifiedObject {
  final String label;
  final int x1, x2, y1, y2;
  double? accuracy;

  IdentifiedObject(this.x1, this.x2, this.y1, this.y2, this.label);

  @override
  String toString() {
    return 'Object{label: $label, x1: $x1, x2: $x2, y1: $y1, y2: $y2}';
  }

  static int overlap(IdentifiedObject o1, IdentifiedObject o2) {
    overlap_length(
      double x_a1,
      double x_a2,
      double x_b1,
      double x_b2,
    ) {
      double overlap = 0;
      if (max(x_a1, x_b1) < min(x_a2, x_b2)) {
        overlap = min(x_a2, x_b2) - max(x_a1, x_b1);
      }

      return overlap.toInt();
    }

    int x = overlap_length(
        o1.x1.toDouble(), o1.x2.toDouble(), o2.x1.toDouble(), o2.x2.toDouble());
    int y = overlap_length(
        o1.y1.toDouble(), o1.y2.toDouble(), o2.y1.toDouble(), o2.y2.toDouble());

    print("${o1.toString()}) | ${o2.toString()}");

    return x * y;
  }
}
