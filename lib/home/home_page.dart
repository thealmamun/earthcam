import 'package:earth_cam/pages/category_list.dart';
import 'package:earth_cam/pages/country_list.dart';
import 'package:earth_cam/pages/favorites.dart';
import 'package:earth_cam/pages/live_videos.dart';
//import 'package:earth_cam/pages/map_view.dart';
import 'package:earth_cam/pages/map_view_new.dart';
import 'package:earth_cam/widgets/navBarWidget/curve_nav_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _pageIndex = 0;
  GlobalKey _bottomNavigationKey = GlobalKey();

  List pages = [
    MyRoute(
      iconData: FontAwesomeIcons.globe,
      size: 30,
      color: Colors.white,
      page: CountryList(),
    ),
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
      page: MapViewNew(),
    ),

    MyRoute(
      iconData: Icons.favorite,
      size: 30,
      color: Colors.white,
      page: Favorites(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBarWidget(
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
        animationCurve: Curves.easeIn,
        animationDuration: Duration(milliseconds: 400),
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














