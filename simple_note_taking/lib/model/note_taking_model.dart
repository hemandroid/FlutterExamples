import 'package:flutter/material.dart';

/// Model to hold the notes information
class NotesModel {
  int id;
  String title;
  String message;
  int noteColor;

  NotesModel({this.id, this.title, this.message, this.noteColor});

  void setUserId(int id) {
    this.id = id;
  }

  Map<String, dynamic> toMap() {
    var data = new Map<String, dynamic>();
    data["title"] = title ?? "";
    data["message"] = message ?? "";
    data["noteColor"] = noteColor ?? Colors.white.value;
    return data;
  }
}
