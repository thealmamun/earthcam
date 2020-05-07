import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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

class CountryCams extends StatefulWidget {
  CountryCams(
      {this.selectedCountry,
      this.selectedCountryTitle,
      this.selectedCountryFlag,
      this.selectedCountryIcon});

  final String selectedCountry;
  final String selectedCountryTitle;
  final String selectedCountryFlag;
  final String selectedCountryIcon;

  @override
  _CountryCamsState createState() => _CountryCamsState();
}

class _CountryCamsState extends State<CountryCams> {
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
                  builder: (context) => ServerVideoPlayer(
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
      },
    );
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
      appBar: AppBar(
          automaticallyImplyLeading: false,
          iconTheme: IconThemeData(color: AppColor.kThemeColor),
          centerTitle: true,
          title: Text(
            widget.selectedCountry,
            style: GoogleFonts.righteous(
                fontSize: 30, color: AppColor.kThemeColor),
          ),
          backgroundColor: Color(0xff28292b),
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
          leading: InkWell(
            onTap: (){
              Navigator.pop(context);
            },
            child: Center(
              child: Text(
                widget.selectedCountryFlag,
                style: TextStyle(fontSize: 30),
              ),
            ),
          )),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: AppColor.kBackgroundColor,
          child: Column(
            children: [
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: Firestore.instance
                      .collection('cams')
                      .where('country', isEqualTo: widget.selectedCountry)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data.documents.length == 0) {
                        return Center(
                            child: NoDataWidget(text: 'No Cams Found'));
                      }
                      return Center(
                        child: Container(
                          child: Column(
                            children: [
                              Expanded(
                                child: GridView.count(
                                  padding: EdgeInsets.all(1.0),
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
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
