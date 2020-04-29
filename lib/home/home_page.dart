import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:earth_cam/pages/category_list.dart';
import 'package:earth_cam/pages/favorites.dart';
import 'package:earth_cam/pages/live_videos.dart';
import 'package:earth_cam/pages/map_view.dart';
import 'package:flutter/material.dart';

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
      color: Colors.white,
      page: LiveVideos(),
    ),
    MyRoute(
      iconData: Icons.my_location,
      size: 30,
      color: Colors.white,
      page: MapView(),
    ),
    MyRoute(
      iconData: Icons.list,
      size: 30,
      color: Colors.white,
      page: CategoryList(),
    ),
    MyRoute(
      iconData: Icons.favorite_border,
      size: 30,
      color: Colors.white,
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
                  color: Color(0xff64cf94),
                ))
            .toList(),
        color: Color(0xff28292b),
        buttonBackgroundColor: Color(0xff28292b),
        backgroundColor: Color(0xff8d9691),
        animationCurve: Curves.easeInOut,
        animationDuration: Duration(milliseconds: 600),
        onTap: (index) {
          setState(() {
            _pageIndex = index;
          });
        },
      ),
//      backgroundColor: Colors.blueAccent,
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














