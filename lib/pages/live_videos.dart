import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:earth_cam/pages/launch_video.dart';
import 'package:earth_cam/pages/search_cams.dart';
import 'package:earth_cam/pages/yt_video_player.dart';
import 'package:earth_cam/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neumorphic/neumorphic.dart';

class LiveVideos extends StatefulWidget {
  @override
  _LiveVideosState createState() => _LiveVideosState();
}

class _LiveVideosState extends State<LiveVideos> {
  Widget _mapList(DocumentSnapshot snapshot) {
    return GridTile(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: NeuCard(
          curveType: CurveType.convex,
          bevel: 10,
          decoration: NeumorphicDecoration(
              color: Color(0xff212121),
              borderRadius: BorderRadius.circular(20)
          ),
          child: Stack(
            children: <Widget>[
              Positioned.fill(
                child: Container(
                  color: Colors.black.withOpacity(0),
                  child: CachedNetworkImage(
                    fit: BoxFit.cover,
                    imageUrl: snapshot.data['imageUrl'],
                    placeholder: (context, url) =>
                        Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) =>
                        Icon(Icons.error),
                  ),
                ),
              ),
              Positioned.fill(
                bottom: 40,
                child: Container(
                  color: Colors.black.withOpacity(0.4),
                  child: IconButton(
                    color: Colors.grey,
                    icon: Icon(
                      Icons.play_circle_filled,
                      size: 35,
                      color: AppColor.kThemeColor,
                    ),
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
                  ),
                ),
              ),
              Positioned.fill(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 60,
                      color: Color(0xff3d3e40),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Text(
                                snapshot.data['camTitle'],
                                style: GoogleFonts.roboto(
                                  fontSize: 14, color: AppColor.kTextColor,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                              icon: Icon(
                                Icons.favorite_border,
                                color: AppColor.kThemeColor,
                              ),
                              onPressed: null),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 10,
        iconTheme: IconThemeData(
          color: AppColor.kThemeColor
        ),
        centerTitle: true,
        title: Text('Camera World',style: GoogleFonts.righteous(fontSize: 30,color: AppColor.kThemeColor),),
        backgroundColor: AppColor.kAppBarBackgroundColor,
        actions: [
          IconButton(
            icon: Icon(
              FontAwesomeIcons.searchLocation,
              size: 25,
            ),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SearchCams()));
            },
          ),
          IconButton(
              icon: Icon(
                Icons.do_not_disturb_off,
                color: AppColor.kThemeColor,
                size: 25,
              ),
              onPressed: null),
        ],
      ),
      body: Center(
        child: Container(
//          color: Color(0xff28292b),
          color: AppColor.kBackgroundColor,
          child: StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance.collection('maps').snapshots(),
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
              }),
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
