// 🐦 Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// 📦 Package imports:
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wakelock/wakelock.dart';

// 🌎 Project imports:
import 'package:earth_cam/services/google_admob.dart';
import 'package:earth_cam/pages/country_list.dart';
import 'package:earth_cam/pages/favorites.dart';
import 'package:earth_cam/pages/live_videos.dart';
import 'package:earth_cam/pages/map_view_new.dart';
import 'package:earth_cam/utils/app_configure.dart';
import 'package:earth_cam/utils/constants.dart';
import 'package:earth_cam/widgets/navBarWidget/curve_nav_bar_widget.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseMessaging _fcm = FirebaseMessaging();
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

  Future<bool> _willPopCallback() async {
    showGeneralDialog(
        context: context,
        // ignore: missing_return
        pageBuilder: (context, anim1, anim2) {},
        barrierDismissible: true,
        barrierColor: Colors.black.withOpacity(0.4),
        barrierLabel: '',
        transitionDuration: Duration(milliseconds: 200),
        transitionBuilder: (context, anim1, anim2, child) {
          return FadeTransition(
            opacity: anim1,
            child: Theme(
              data: Theme.of(context)
                  .copyWith(dialogBackgroundColor: Colors.transparent),
              child: AlertDialog(
                contentPadding: EdgeInsets.all(1),
                content: Container(
                  height: 160,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: AppColor.kAppBarBackgroundColor,
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        blurRadius: 30,
                        spreadRadius: 1,
                        offset: Offset(0, 5),
                        color: Colors.grey.withOpacity(0.2),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        AppConfig.appName,
                        style: AppConfig.appNameStyle,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Center(
                        child: Text(
                          'Do you want to exit this application?',
                          style: GoogleFonts.righteous(
                            fontSize: 17,
                            color: AppColor.kThemeColor,
                          ),
                        ),
                      ),
                      Text(
                        'We hate to see you leave...',
                        style: GoogleFonts.righteous(
                          fontSize: 15,
                          color: AppColor.kThemeColor,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          FlatButton(
                            onPressed: () => SystemNavigator.pop(),
                            child: new Text(
                              'Yes',
                              style: GoogleFonts.righteous(
                                fontSize: 15,
                                color: AppColor.kThemeColor,
                              ),
                            ),
                          ),
                          FlatButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: new Text(
                              'No',
                              style: GoogleFonts.righteous(
                                fontSize: 15,
                                color: AppColor.kThemeColor,
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        });
    // then

    return true; // return true if the route to be popped
  }

  @override
  void initState() {
    super.initState();
//    GoogleAdMob.showBannerAd();
    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: ListTile(
              title: Text(message['notification']['title']),
              subtitle: Text(message['notification']['body']),
            ),
            actions: <Widget>[
              FlatButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Ok')),
            ],
          ),
        );
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
    );
    Wakelock.enable();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _willPopCallback,
      child: Scaffold(
        backgroundColor: Color(0xff28292b),
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
      ),
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
