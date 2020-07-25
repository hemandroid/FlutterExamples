import 'dart:async';
import 'package:flutter/material.dart';
import 'package:simplenotetaking/database/note_taking_db.dart';
import 'package:simplenotetaking/model/note_taking_model.dart';
import 'package:simplenotetaking/ui/home_screen.dart';
import 'package:simplenotetaking/utils/notes_tile_color_generator.dart';

class FormScreenUI extends StatefulWidget {
  @override
  _FormScreenState createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreenUI> {
  NoteTakingDbHelper _noteTakingDbHelper;
  NotesModel _notesModel;

  /// Controller to clear the text on tapping the save button.
  TextEditingController titleController = TextEditingController();
  TextEditingController messageController = TextEditingController();
  String title;
  String message;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: _buildNoteTakingForm(context),
      ),
    );
  }

  Widget _buildNoteTakingForm(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 15.0, right: 10.0),
      padding: const EdgeInsets.all(10.0),
      decoration: _customLayout(),
      child: Column(
        children: <Widget>[
          TextField(
            onChanged: (value) {
              title = value;
            },
            controller: titleController,
            decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                  borderSide: BorderSide(width: 1, color: Colors.green),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                  borderSide: BorderSide(width: 1, color: Colors.green),
                ),
                hintText: 'Please Enter Title'),
          ),
          Padding(
            padding: EdgeInsets.all(10.0),
          ),
          TextField(
            maxLines: 10,
            onChanged: (value) {
              message = value;
            },
            controller: messageController,
            maxLength: 150,
            decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                  borderSide: BorderSide(width: 1, color: Colors.orange),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                  borderSide: BorderSide(width: 1, color: Colors.orange),
                ),
                hintText: 'Please Enter message',
                fillColor: Color(0xFFF2F2F2),
                filled: true,
                contentPadding: EdgeInsets.all(15.0)),
          ),
          Padding(
            padding: EdgeInsets.all(10.0),
          ),
          _saveButton(context),
          Padding(
            padding: EdgeInsets.all(5.0),
          ),
        ],
      ),
    );
  }

  Widget _saveButton(BuildContext context) {
    return RawMaterialButton(
      splashColor: Colors.red[400],
      fillColor: Colors.blue,
      padding: EdgeInsets.all(12),
      shape: StadiumBorder(),
      onPressed: () {
        _addNotes();
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return HomeScreenWidget(
            selectedIndex: 0,
          );
        }));
      },
      child: Container(
        padding: const EdgeInsets.only(left: 40.0, right: 40.0),
        child: Text(
          'SAVE',
          style: TextStyle(
              fontWeight: FontWeight.w500, fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }

  BoxDecoration _customLayout() {
    return BoxDecoration(border: Border.all());
  }

  /// Async function to add the notes into DB in the background
  /// Here we have TextEditingController to clear the text from UI box
  /// after saving into DB.
  Future _addNotes() async {
    _noteTakingDbHelper = NoteTakingDbHelper();
    _notesModel = new NotesModel(
        title: title,
        message: message,
        noteColor: NotesTileColorGenerator.randomGenerator().value);
    _notesModel.setUserId(this._notesModel.id);
    await _noteTakingDbHelper.saveNotes(_notesModel);
    titleController.clear();
    messageController.clear();
  }
}
