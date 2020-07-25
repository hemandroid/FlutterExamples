import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:simplenotetaking/database/note_taking_db.dart';
import 'package:simplenotetaking/model/note_taking_model.dart';

class NotesScreenUI extends StatefulWidget {
  @override
  _NotesScreenUIState createState() => _NotesScreenUIState();
}

class _NotesScreenUIState extends State<NotesScreenUI> {
  NoteTakingDbHelper _noteTakingDbHelper;
  List<NotesModel> _notesList;
  StreamController<List<NotesModel>> sendNotesData =
      new StreamController<List<NotesModel>>();

  /// First method which executes and accomplish the primary task before loading the UI
  @override
  void initState() {
    super.initState();
    _noteTakingDbHelper = NoteTakingDbHelper();
    loadNotes();
  }

  /// Closing the controller once the job has been done. It's really matters
  @override
  void dispose() {
    super.dispose();
    sendNotesData.close();
  }

  /// loading the data asynchronously from the DB
  loadNotes() async {
    var getNotes = await _noteTakingDbHelper.getNotes();
    sendNotesData.add(getNotes);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(left: 7.0, right: 4.0),
        child: _buildUI(context));
  }

  _buildUI(BuildContext context) {
    /// Global key has been assigned to StaggeredGridView key parameter
    GlobalKey _stagKey = GlobalKey();

    /// Here we used the StreamBuilder to get the fast live updates from the DB
    return StreamBuilder(
      stream: sendNotesData.stream,
      builder:
          (BuildContext context, AsyncSnapshot<List<NotesModel>> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.length != 0) {
            _notesList = snapshot.data;

            /// We are using StaggeredGridView with the help of library.
            /// Refer to pubspec.yaml file for flutter_staggered_grid_view
            return new StaggeredGridView.count(
              key: _stagKey,
              crossAxisSpacing: 4,
              mainAxisSpacing: 4,
              crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
              children: List.generate(_notesList.length, (i) {
                return _notesTile(context, i);
              }),
              staggeredTiles: _tilesForView(),
            );
          } else {
            /// If DB was empty then StreamBuilder return the below UI
            return Center(
                child: Text(
              "Your notes is empty",
              style: GoogleFonts.mcLaren(fontSize: 20.0, color: Colors.black),
            ));
          }
        }

        /// If the StreamBuilder taking more time to load the data or
        /// Any error has been Occurred, then the below snippet will execute.
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  /// Tile design in the StaggeredGridView
  _notesTile(BuildContext context, int index) {
    Color msgColor = Color(_notesList[index].noteColor);
    if (msgColor == Colors.white) {
      msgColor = Colors.black;
    } else {
      msgColor = Colors.white;
    }
    return Card(
      color: Color(_notesList[index].noteColor),
      margin: const EdgeInsets.all(3.0),
      child: Container(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              _notesList[index].title,
              style: GoogleFonts.mavenPro(
                  fontSize: 20.0, fontWeight: FontWeight.w700),
            ),
            Padding(
              padding: EdgeInsets.all(5.0),
            ),
            Divider(
              color: Colors.grey[350],
              height: 5,
              thickness: 1.2,
            ),
            Padding(
              padding: EdgeInsets.all(5.0),
            ),
            Text(
              _notesList[index].message,
              style: GoogleFonts.mcLaren(fontSize: 15.0, color: msgColor),
            )
          ],
        ),
      ),
    );
  }

  /// Generating the StaggeredListView based on the list size.
  List<StaggeredTile> _tilesForView() {
    return List.generate(_notesList.length, (index) {
      return StaggeredTile.fit(1);
    });
  }
}
