import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:earth_cam/model/cams.dart';
import 'package:earth_cam/pages/launch_video.dart';
import 'package:earth_cam/pages/search_cams.dart';
import 'package:earth_cam/pages/yt_video_player.dart';
import 'package:earth_cam/services/local_db.dart';
import 'package:earth_cam/utils/constants.dart';
import 'package:earth_cam/widgets/cams_grid_tile.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neumorphic/neumorphic.dart';

GlobalKey<ScaffoldState> scaffoldKey =
    GlobalKey<ScaffoldState>(debugLabel: '_homeScreenkey');

class LiveVideos extends StatefulWidget {
  @override
  _LiveVideosState createState() => _LiveVideosState();
}

class _LiveVideosState extends State<LiveVideos> {
  Future<List<Cams>> cams;
  var dbHelper;
  bool liked = false;

  Widget _mapList(DocumentSnapshot snapshot) {
    return CamsGridTile(
      context: context,
      camTitle: snapshot.data['camTitle'],
      imageUrl: snapshot.data['imageUrl'],
      onPressed: () {
        print('tapped');
        if (snapshot.data['camType'] == 'Youtube') {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => YtVideoPlayerPage(
                        url: snapshot.data['streamUrl'],
                      )));
        } else {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => LaunchVideo(
                        url: snapshot.data['streamUrl'],
                      )));
        }
      },
      onPressedFavourite: () {
        Cams c = Cams(
          camId: snapshot.data['camId'],
          camTitle: snapshot.data['camTitle'],
          camType: snapshot.data['camType'],
          imageUrl: snapshot.data['imageUrl'],
          streamUrl: snapshot.data['streamUrl'],
        );
        dbHelper.save(c, context);
        refreshList();
        setState(() {
          liked = true;
        });
        Future.delayed(const Duration(milliseconds: 3000), () {
          setState(() {
            liked = false;
          });
        });
      },
    );
  }

  refreshList() {
    setState(() {
      cams = dbHelper.getCams();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dbHelper = DBHelper();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        elevation: 10,
        iconTheme: IconThemeData(color: AppColor.kThemeColor),
        centerTitle: true,
        title: Text(
          'Camera World',
          style:
              GoogleFonts.righteous(fontSize: 30, color: AppColor.kThemeColor),
        ),
        backgroundColor: AppColor.kAppBarBackgroundColor,
        actions: [
          GestureDetector(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                FontAwesomeIcons.searchLocation,
                size: 25,
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) {
                    return SearchCams();
                  },
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    return FadeTransition(
                      opacity: animation,
                      child: child,
                    );
                  },
                ),
              );
//              Navigator.push(context,
//                  MaterialPageRoute(builder: (context) => SearchCams()));
            },
          ),
          GestureDetector(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.do_not_disturb_off,
                  color: AppColor.kThemeColor,
                  size: 25,
                ),
              ),
              onTap: null),
        ],
      ),
      body: Center(
        child: Container(
          color: AppColor.kBackgroundColor,
          child: liked == false
              ? StreamBuilder<QuerySnapshot>(
                  stream: Firestore.instance
                      .collection('maps')
                      .orderBy('updatedAt', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Center(
                        child: Container(
                          child: Column(
                            children: [
                              Expanded(
                                child: GridView.count(
                                  crossAxisCount: 2,
                                  childAspectRatio: 1.0,
                                  mainAxisSpacing: 4.0,
                                  crossAxisSpacing: 4.0,
                                  children: snapshot.data.documents
                                      .map((doc) => _mapList(doc))
                                      .toList(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    } else
                      return Center(child: CircularProgressIndicator());
                  })
              : Center(
                  child: Container(
                    width: 50,
                    height: 50,
                    child: FlareActor("assets/flare/Favorite.flr",
                        shouldClip: false,
                        animation: "Favorite" //_animationName
                        ),
                  ),
                ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('Drawer Header'),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              title: Text('Item 1'),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
            ListTile(
              title: Text('Item 2'),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
          ],
        ),
      ),
    );
  }
}
