import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

class Favorites extends StatefulWidget {
  @override
  _FavoritesState createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Favorites'),
          actions: [
            IconButton(
                icon: Icon(
                  Icons.search,
                  color: Colors.white,
                  size: 30,
                ),
                onPressed: null),
            IconButton(
                icon: Icon(
                  Icons.do_not_disturb_off,
                  color: Colors.white,
                  size: 25,
                ),
                onPressed: null),
          ],
        ),
        body:LayoutBuilder(
          builder: (BuildContext context, BoxConstraints viewportConstraints) {
            return ConstrainedBox(
              constraints: BoxConstraints(
                  minHeight: viewportConstraints.maxHeight,
                  minWidth: viewportConstraints.maxWidth),
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    container1,
                  ],
                ),
              ),
            );
          },
        ),
    );
  }
}

Widget get container1 {
  return Padding(
    padding: const EdgeInsets.all(15.0),
    child: DottedBorder(
      padding: EdgeInsets.all(4),
      dashPattern: [9, 5],
      child: Container(
        height: 100,
        width: double.maxFinite,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '0 Favorite Videos',
              style: TextStyle(fontSize: 30),
            ),
          ],
        ),
      ),
    ),
  );
}


