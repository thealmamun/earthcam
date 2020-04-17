import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

class DashBoard extends StatefulWidget {
  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  int pageIndex = 0;

  onPageChanged(int pageIndex) {
    setState(() {
      this.pageIndex = pageIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lime,
      appBar: AppBar(
        centerTitle: true,
        title: Text('Live Cam'),
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
      body: PageView(
        children: [
          RaisedButton(onPressed: null,child: Text('Live Videos'),),
          RaisedButton(onPressed: null,child: Text('MapView'),),
          RaisedButton(onPressed: null,child: Text('Categories'),),
          RaisedButton(onPressed: null,child: Text('Favorites'),),
        ],
        onPageChanged: onPageChanged,
      ),
      bottomNavigationBar: CurvedNavigationBar(
        index: 0,
        backgroundColor: Colors.blueAccent,
        items: <Widget>[
          IconButton(
              icon: Icon(Icons.videocam, size: 30, color: Colors.indigo),
              onPressed: null),
          IconButton(
              icon: Icon(Icons.my_location, size: 30, color: Colors.indigo),
              onPressed: null),
          IconButton(
              icon: Icon(Icons.list, size: 30, color: Colors.indigo),
              onPressed: null),
          IconButton(
              icon: Icon(
                Icons.favorite_border,
                size: 30,
                color: Colors.indigo,
              ),
              onPressed: null)
        ],
        onTap: (index) {
          setState(() {
            pageIndex = index;
          });
        },
      ),
    );
  }
}
