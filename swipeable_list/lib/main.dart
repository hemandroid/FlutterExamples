import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() => runApp(SwipeListWidget());

class SwipeListWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.amber),
      home: SwipeListUI(),
    );
  }
}

class SwipeListUI extends StatefulWidget {
  @override
  _SwipeListUIState createState() => _SwipeListUIState();
}

class _SwipeListUIState extends State<SwipeListUI> {
  final swipeList = new List<String>.generate(50, (i) => "Number $i");
  bool liked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Swipe List'),
      ),
      body: Container(
        child: ListView.builder(
            itemCount: swipeList.length,
            itemBuilder: (context, index) {
              String item = swipeList[index];
              return Dismissible(
                key: Key(item),
                child: ListTile(
                  title: Text('${swipeList[index]}'),),
                onDismissed: (DismissDirection dir) {
                  setState(() => this.swipeList.removeAt(index));
                  Scaffold.of(context).showSnackBar(SnackBar(
                    content: Text(dir == DismissDirection.startToEnd
                        ? '$item removed'
                        : '$item liked',),
                    action: SnackBarAction(
                      label: 'Undo',
                      onPressed: () {
                        setState(() => this.swipeList.insert(index, item));
                      },
                    ),
                  ));
                },
                background: Container(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Icon(Icons.delete),
                  ),
                  color: Colors.orange,
                  alignment: Alignment.centerLeft,
                ),
                secondaryBackground: Container(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Icon(Icons.thumb_up),
                  ),
                  color: Colors.lightGreen,
                  alignment: Alignment.centerRight,
                ),
              );
            }),
      ),
    );
  }
}
