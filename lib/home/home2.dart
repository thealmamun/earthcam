import 'package:earth_cam/pages/category_list.dart';
import 'package:earth_cam/pages/favorites.dart';
import 'package:earth_cam/pages/live_videos.dart';
import 'package:earth_cam/pages/map_view.dart';
import 'package:earth_cam/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:persistent_bottom_nav_bar/models/persisten-bottom-nav-item.widget.dart';
import 'package:persistent_bottom_nav_bar/models/persistent-nav-bar-scaffold.widget.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class Home2 extends StatefulWidget {
  @override
  _Home2State createState() => _Home2State();
}

class _Home2State extends State<Home2>{

  PersistentTabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PersistentTabController(initialIndex: 0);
  }

  List<Widget> _buildScreens() {
    return [LiveVideos(), MapView(), CategoryList(), Favorites()];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(Icons.videocam),
        title: ("All Cams"),
        activeColor: AppColor.kThemeColor,
        inactiveColor: Colors.grey,
        isTranslucent: false,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(FontAwesomeIcons.globeAmericas),
        title: ("Map View"),
        activeColor: AppColor.kThemeColor,
        inactiveColor: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.view_list),
        title: ("Categories"),
        activeColor: AppColor.kThemeColor,
        inactiveColor: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.favorite_border),
        title: ("Favourites"),
        activeColor: AppColor.kThemeColor,
        inactiveColor: Colors.grey,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      showElevation: true,
      backgroundColor: AppColor.kAppBarBackgroundColor,
      controller: _controller,
      screens: _buildScreens(),
      items: _navBarsItems(),
      onItemSelected: (index){
        setState(() {
          _controller.index = index;
        });
        setState(() {

        });
      },
      selectedIndex: _controller.index,
      itemCount: 4,
      neumorphicProperties: NeumorphicProperties(
        curveType: CurveType.convex,
        bevel: 10,
      ),
      navBarStyle: NavBarStyle.neumorphic, // Choose the nav bar style with this property
    );
  }
}
