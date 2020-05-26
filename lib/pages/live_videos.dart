// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';

// 🌎 Project imports:
import 'package:earth_cam/model/cams.dart';
import 'package:earth_cam/pages/general_video_player.dart';
import 'package:earth_cam/pages/youtube_video_player.dart';
import 'package:earth_cam/services/google_admob.dart';
import 'package:earth_cam/services/local_db.dart';
import 'package:earth_cam/utils/app_configure.dart';
import 'package:earth_cam/utils/constants.dart';
import 'package:earth_cam/widgets/cams_grid_tile.dart';

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
                        title: snapshot.data['camTitle'],
                        imageUrl: snapshot.data['imageUrl'],
                      )));
        } else {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ServerVideoPlayer(
                        url: snapshot.data['streamUrl'],
                        title: snapshot.data['camTitle'],
                        imageUrl: snapshot.data['imageUrl'],
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
      },
    );
  }

  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 10,
        iconTheme: IconThemeData(color: AppColor.kThemeColor),
        centerTitle: true,
        title: Text(
          'Live Cams',
          style: AppConfig.appNameStyle,
        ),
        backgroundColor: AppColor.kAppBarBackgroundColor,
        actions: [
          AppConfig.appBarSearchButton(context),
        ],
        leading: AppConfig.appLeadingIcon,
      ),
      body: Center(
        child: Container(
            color: AppColor.kBackgroundColor,
            child: StreamBuilder<QuerySnapshot>(
                stream: Firestore.instance
                    .collection('cams')
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
                })),
      ),
//      drawer: Drawer(
//        child: ListView(
//          // Important: Remove any padding from the ListView.
//          padding: EdgeInsets.zero,
//          children: <Widget>[
//            DrawerHeader(
//              child: Text('Drawer Header'),
//              decoration: BoxDecoration(
//                color: Colors.blue,
//              ),
//            ),
//            ListTile(
//              title: Text('Item 1'),
//              onTap: () {
//                // Update the state of the app.
//                // ...
//              },
//            ),
//            ListTile(
//              title: Text('Item 2'),
//              onTap: () {
//                // Update the state of the app.
//                // ...
//              },
//            ),
//          ],
//        ),
//      ),
    );
  }
}
