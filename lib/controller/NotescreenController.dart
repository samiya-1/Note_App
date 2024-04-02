import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:noteapp/core/constants/ColorConstants.dart';

class NoteScreenController {
  static List notesListkeys = [];

  static List<Color> colorList = [
    ColorConstants.clr1,
    ColorConstants.clr2,
    ColorConstants.clr3,
    ColorConstants.clr4,
  ];
  static var mybox = Hive.box('noteBox');
  //add

  static void addNote(
      {required String title,
      required String des,
      required String date,
      int clrIndex = 0}) {
    mybox.add({
      "title": title,
      "des": des,
      "date": date,
      "colorIndex": clrIndex,
    });
    notesListkeys = mybox.keys.toList();
  }

  static getInitKeys() {
    notesListkeys = mybox.keys.toList();
  }

  static deleteNote(var key) {
    mybox.delete(key);
    notesListkeys = mybox.keys.toList();
  }

  static void editNote(
      {required var currentKey,
      required String title,
      required String des,
      required String date,
      int clrIndex = 0}) {
    mybox.put(
        currentKey,
        ({
          "title": title,
          "des": des,
          "date": date,
          "colorIndex": clrIndex,
        }));
  }
}
