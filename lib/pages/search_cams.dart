import 'dart:ui';

import 'package:earth_cam/model/cams.dart';
import 'package:earth_cam/pages/launch_video.dart';
import 'package:earth_cam/pages/yt_video_player.dart';
import 'package:earth_cam/services/database.dart';
import 'package:earth_cam/services/local_db.dart';
import 'package:earth_cam/utils/constants.dart';
import 'package:earth_cam/widgets/cams_grid_tile.dart';
import 'package:earth_cam/widgets/no_data_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
    // TODO: implement initState
    super.initState();
    dbHelper = DBHelper();
  }

  Widget buildResultCard(data) {
    return CamsGridTile(
      context: context,
      camTitle: data['camTitle'],
      imageUrl: data['imageUrl'],
      onPressed: () {
        print('tapped');
        if (data['camType'] == 'Youtube') {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => YtVideoPlayerPage(
                        url: data['streamUrl'],
                      )));
        } else {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => LaunchVideo(
                        url: data['streamUrl'],
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

//    var capitalizedValue =
//        value.substring(0, 1).toUpperCase() + value.substring(1);

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
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppColor.kThemeColor),
        centerTitle: true,
        title: Text(
          'Search',
          style:
              GoogleFonts.righteous(fontSize: 30, color: AppColor.kThemeColor),
        ),
        backgroundColor: Color(0xff28292b),
        actions: [
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
    );
  }
}
