// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 🌎 Project imports:
import 'package:earth_cam/model/cams.dart';
import 'package:earth_cam/pages/general_video_player.dart';
import 'package:earth_cam/pages/youtube_video_player.dart';
import 'package:earth_cam/services/google_admob.dart';
import 'package:earth_cam/services/local_db.dart';
import 'package:earth_cam/utils/app_configure.dart';
import 'package:earth_cam/utils/constants.dart';
import 'package:earth_cam/widgets/cams_grid_tile.dart';
import 'package:earth_cam/widgets/no_data_widget.dart';

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
                                        title: e.camTitle,
                                        imageUrl: e.imageUrl,
                                      )));
                        } else {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ServerVideoPlayer(
                                        url: e.streamUrl,
                                      title: e.camTitle,
                                    imageUrl: e.imageUrl,
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
  void initState() {
    super.initState();
    GoogleAdMob().showInterstitialAds();
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
          style: AppConfig.appNameStyle,
        ),
        backgroundColor: AppColor.kAppBarBackgroundColor,
        actions: [
          AppConfig.appBarSearchButton(context),
        ],
        leading: AppConfig.appLeadingIcon,
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
              if (snapshot.data.length == 0) {
                return NoDataWidget(text: 'No Favourite Cams');
              }
              return _mapList(snapshot.data, context);
            }
            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
