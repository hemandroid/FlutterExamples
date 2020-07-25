import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:simplenotetaking/ui/form_screen.dart';
import 'package:simplenotetaking/ui/notes_screen.dart';

class HomeScreenWidget extends StatelessWidget {

  final int selectedIndex;

  HomeScreenWidget({this.selectedIndex}): super();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.lightBlue),
      home: HomeScreenUI(selectedIndex: selectedIndex,),
    );
  }
}

class HomeScreenUI extends StatefulWidget {
  final int selectedIndex;

  HomeScreenUI({this.selectedIndex}):super();

  @override
  _HomeScreenUIState createState() => _HomeScreenUIState();
}

class _HomeScreenUIState extends State<HomeScreenUI> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _noteTakingArea(),
    );
  }

  Widget _noteTakingArea() {
    return Row(
      children: <Widget>[
        /// NavigationRail class has been introduced in Flutter 1.17
        NavigationRail(
          selectedIndex: _selectedIndex,
          groupAlignment: 0.0,
          backgroundColor: Color(0xffff6d00),
          labelType: NavigationRailLabelType.all,
          selectedLabelTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 13,
            letterSpacing: 0.8,
            decoration: TextDecoration.underline,
            decorationThickness: 2.0,
          ),
          unselectedLabelTextStyle:
              TextStyle(fontSize: 13, letterSpacing: 0.8, color: Colors.black),
          destinations: [
            _navigationRailDestination("Database"),
            _navigationRailDestination("Form"),
          ],
          onDestinationSelected: (int index) {
            setState(() {
              _selectedIndex = index;
            });
          },
        ),
        VerticalDivider(
          thickness: 5,
          width: 1,
          color: Colors.lightBlueAccent,
        ),
        _noteTakingSpace(_selectedIndex)
      ],
    );
  }

  /// Destination view is like a button for the NavigationRail class.
  NavigationRailDestination _navigationRailDestination(String title) {
    return NavigationRailDestination(
      icon: SizedBox.shrink(),
      label: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        child: RotatedBox(
          quarterTurns: -1,
          child: Text(title, style: GoogleFonts.mcLaren(fontSize: 20.0),),
        ),
      ),
    );
  }

  Widget _noteTakingSpace(int selectedIndex) {
    switch (selectedIndex) {
      case 0:
        return Expanded(
          child: Center(child: NotesScreenUI()),
        );
        break;
      case 1:
        return Expanded(
          child: Center(child: FormScreenUI()),
        );
    }
    return IgnorePointer();
  }
}
