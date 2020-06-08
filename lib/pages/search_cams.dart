// 🎯 Dart imports:
import 'dart:ui';

// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:admob_flutter/admob_flutter.dart';

// 🌎 Project imports:
import 'package:earth_cam/pages/live_videos.dart';
import 'package:earth_cam/model/cams.dart';
import 'package:earth_cam/pages/general_video_player.dart';
import 'package:earth_cam/pages/youtube_video_player.dart';
import 'package:earth_cam/services/database.dart';
import 'package:earth_cam/services/local_db.dart';
import 'package:earth_cam/utils/app_configure.dart';
import 'package:earth_cam/utils/constants.dart';
import 'package:earth_cam/widgets/cams_grid_tile.dart';
import 'package:earth_cam/widgets/no_data_widget.dart';

class SearchCams extends StatefulWidget {
  @override
  _SearchCamsState createState() => _SearchCamsState();
}

class _SearchCamsState extends State<SearchCams> {
  var queryResultSet = [];
  var tempSearchStore = [];

  bool searchFound = true;
  Future<List<Cams>> cams;
  var dbHelper;
  bool liked = false;

//  refreshList() {
//    setState(() {
//      cams = dbHelper.getCams();
//    });
//  }

  @override
  void initState() {
    super.initState();
//    GoogleAdMob.showInterstitialAds();
    dbHelper = DBHelper();
  }

  Widget buildResultCard(data) {
    return CamsGridTile(
      context: context,
      camTitle: data['camTitle'],
      imageUrl: data['imageUrl'],
      onPressed: () {
        print('tapped');
        print('Countt in country :$count');
        count = count + 1;
        print('Countt: $count');
        if (count == 4) {
          count = 0;
        }
        if (data['camType'] == 'Youtube') {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => YtVideoPlayerPage(
                        url: data['streamUrl'],
                        title: data['camTitle'],
                        imageUrl: data['imageUrl'],
                        check: count,
                      )));
        } else {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ServerVideoPlayer(
                        url: data['streamUrl'],
                        title: data['camTitle'],
                        imageUrl: data['imageUrl'],
                        check: count,
                      )));
        }
      },
      onPressedFavourite: () {
        Cams c = Cams(
          camId: data['camId'],
          camTitle: data['camTitle'],
          camType: data['camType'],
          imageUrl: data['imageUrl'],
          streamUrl: data['streamUrl'],
        );
        dbHelper.save(c, context);
      },
    );
  }

  initiateSearch(value) {
    if (value.length == 0) {
      setState(() {
        queryResultSet = [];
        tempSearchStore = [];
      });
    }

    if (queryResultSet.length == 0 && value.length == 1) {
      searchByName(value).then((docs) {
        print(docs.documents.length);
        setState(() {
          searchFound = true;
        });
        for (int i = 0; i < docs.documents.length; ++i) {
          queryResultSet.add(docs.documents[i].data);
          setState(() {
            tempSearchStore.add(queryResultSet[i]);
          });
        }
        if (docs.documents.length == 0) {
          setState(() {
            searchFound = false;
          });
        }
      });
    } else {
      tempSearchStore = [];
      queryResultSet.forEach((element) {
        if (element['camTitle'].toLowerCase().contains(value.toLowerCase()) ==
            true) {
          if (element['camTitle'].toLowerCase().indexOf(value.toLowerCase()) ==
              0) {
            setState(() {
              tempSearchStore.add(element);
            });
          }
        }
      });
    }
    if (tempSearchStore.length == 0 && value.length > 1) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 10,
        iconTheme: IconThemeData(color: AppColor.kThemeColor),
        centerTitle: true,
        title: Text(
          'Search..',
          style: AppConfig.appNameStyle,
        ),
        backgroundColor: AppColor.kAppBarBackgroundColor,
        actions: [],
      ),
      body: Center(
        child: Container(
          color: AppColor.kBackgroundColor,
          child: ListView(children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Theme(
                data: ThemeData(
                  hintColor: AppColor.kThemeColor,
                  primarySwatch: Colors.grey,
                ),
                child: TextField(
                  style: new TextStyle(color: Colors.white70),
                  onChanged: (val) {
                    initiateSearch(val);
                  },
                  decoration: new InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      borderSide: BorderSide(
                        width: 1,
                        color: AppColor.kThemeColor,
                      ),
                    ),
                    focusColor: AppColor.kThemeColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(4),
                      ),
                      borderSide: BorderSide(
                        width: 1,
                        color: Colors.yellowAccent,
                      ),
                    ),
//                        border: new OutlineInputBorder(),
                    helperText: 'Search by name...',
                    labelText: 'Search',
                    prefixIcon: const Icon(
                      Icons.search,
                      color: AppColor.kThemeColor,
                    ),

                    suffixStyle: const TextStyle(
                      color: Colors.green,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            searchFound
                ? GridView.count(
                    padding: EdgeInsets.only(left: 10.0, right: 10.0),
                    crossAxisCount: 2,
                    crossAxisSpacing: 4.0,
                    mainAxisSpacing: 4.0,
                    primary: false,
                    shrinkWrap: true,
                    children: tempSearchStore.map((element) {
                      return buildResultCard(element);
                    }).toList())
                : NoDataWidget(
                    text:
                        'No results found,                    Try a different search!',
                  ),
          ]),
        ),
      ),
      bottomNavigationBar: AdmobBanner(
        adUnitId: AppConfig.bannerAdId,
        adSize: AdmobBannerSize.ADAPTIVE_BANNER(
          width: size.width.toInt(),
        ),
      ),
    );
  }
}
