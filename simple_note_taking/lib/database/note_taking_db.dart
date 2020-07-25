import 'dart:async';

import 'package:simplenotetaking/model/note_taking_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class NoteTakingDbHelper {
  static final NoteTakingDbHelper _noteTakingDbHelper =
      new NoteTakingDbHelper.internal();

  NoteTakingDbHelper.internal();

  factory NoteTakingDbHelper() => _noteTakingDbHelper;

  final String noteTakingTable = 'NotesTable';

  static Database _notesDatabase;

  Future<Database> get db async {
    if (_notesDatabase != null) {
      return _notesDatabase;
    }
    _notesDatabase = await initDb();

    return _notesDatabase;
  }

  initDb() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'notes.db');
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  void _onCreate(Database db, int dbVersion) async {
    await db.execute(
        "CREATE TABLE $noteTakingTable(id INTEGER PRIMARY KEY, title TEXT, message TEXT, noteColor INTEGER)");
  }

  Future<int> saveNotes(NotesModel notesModel) async {
    var dbClient = await db;
    int result = await dbClient.insert(noteTakingTable, notesModel.toMap());
    return result;
  }

  Future<List<NotesModel>> getNotes() async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM NotesTable');
    List<NotesModel> notesList = new List();
    for (int i = 0; i < list.length; i++) {
      var notes = new NotesModel(
        title: list[i]["title"],
        message: list[i]["message"],
        noteColor: list[i]["noteColor"],
      );
      notes.setUserId(list[i]["id"]);
      notesList.add(notes);
    }
    return notesList;
  }

}
