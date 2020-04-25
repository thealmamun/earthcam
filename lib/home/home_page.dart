import 'package:earth_cam/pages/categories.dart';
import 'package:earth_cam/pages/favorites.dart';
import 'package:earth_cam/pages/live_videos-o.dart';
import 'package:earth_cam/pages/live_videos.dart';
import 'package:earth_cam/pages/map_view.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _pageIndex = 0;
  GlobalKey _bottomNavigationKey = GlobalKey();

  List pages = [
    MyRoute(
      iconData: Icons.videocam,
      size: 30.0,
      color: Colors.indigo,
      page: LiveVideos(),
    ),
    MyRoute(
      iconData: Icons.my_location,
      size: 30,
      color: Colors.indigo,
      page: MapView(),
    ),
    MyRoute(
      iconData: Icons.list,
      size: 30,
      color: Colors.indigo,
      page: Categories(),
    ),
    MyRoute(
      iconData: Icons.favorite_border,
      size: 30,
      color: Colors.indigo,
      page: Favorites(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        index: 0,
        height: 50.0,
        items: pages
            .map((p) => Icon(
                  p.iconData,
                  size: 30,
                ))
            .toList(),
        color: Colors.white,
        buttonBackgroundColor: Colors.white,
        backgroundColor: Colors.blueAccent,
        animationCurve: Curves.easeInOut,
        animationDuration: Duration(milliseconds: 600),
        onTap: (index) {
          setState(() {
            _pageIndex = index;
          });
        },
      ),
      backgroundColor: Colors.blueAccent,
      body: pages[_pageIndex].page,
    );
  }
}

class MyRoute {
  final IconData iconData;
  final Widget page;
  final double size;
  final Color color;

  MyRoute({this.iconData, this.page, this.size, this.color});
}














