import 'package:earth_cam/model/cams.dart';
import 'package:earth_cam/pages/search_cams.dart';
import 'package:earth_cam/pages/server_video_player.dart';
import 'package:earth_cam/pages/yt_video_player.dart';
import 'package:earth_cam/services/local_db.dart';
import 'package:earth_cam/utils/constants.dart';
import 'package:earth_cam/widgets/cams_grid_tile.dart';
import 'package:earth_cam/widgets/no_data_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class Favorites extends StatefulWidget {
  @override
  _FavoritesState createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  var dbHelper = DBHelper();
  Future<List<Cams>> cams;
  List<Cams> cam = [];
  bool favPress = false;

//  @override
//  void initState() {
//    // TODO: implement initState
//    super.initState();
////    dbHelper = DBHelper();
////    DBHelper().getCams();
////    cams = dbHelper.getCams();
//    print('inisstate');
//  }

  refreshList() {
    setState(() {
      cams = dbHelper.getCams();
    });
  }

  Widget _mapList(List<Cams> cams, BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: GridView.count(
            crossAxisCount: 2,
            childAspectRatio: 1.0,
            mainAxisSpacing: 4.0,
            crossAxisSpacing: 4.0,
            children: cams
                .map((e) => CamsGridTile(
                      context: context,
                      camTitle: e.camTitle,
                      imageUrl: e.imageUrl,
                      onPressed: () {
                        print('tapped');
                        if (e.camType == 'Youtube') {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => YtVideoPlayerPage(
                                        url: e.streamUrl,
                                      )));
                        } else {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ServerVideoPlayer(
                                        url: e.streamUrl,
                                      )));
                        }
                      },
                      onPressedFavourite: () {
                        dbHelper.delete(e.camId);
                        refreshList();
                        print('removed');
                      },
                    ))
                .toList(),
          ),
        ),
      ],
    );
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
          'Favourites',
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
        ],
      ),
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          alignment: Alignment.center,
          color: AppColor.kBackgroundColor,
          child: FutureBuilder(
            future: dbHelper.getCams(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if(snapshot.data.length == 0) {
                  return NoDataWidget(text:'No Favourite Cams');
                }
                return _mapList(snapshot.data, context);
              }
              return CircularProgressIndicator();
            },
          )),
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




