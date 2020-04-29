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

class CategoryCams extends StatefulWidget {
  CategoryCams(
      {this.selectedCategory,
      this.selectedCategoryTitle,
      this.selectedCategoryImage,this.selectedCategoryIcon});

  final String selectedCategory;
  final String selectedCategoryTitle;
  final String selectedCategoryImage;
  final String selectedCategoryIcon;

  @override
  _CategoryCamsState createState() => _CategoryCamsState();
}

class _CategoryCamsState extends State<CategoryCams> {
  Widget _mapList(DocumentSnapshot snapshot) {
    return GridTile(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Material(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          elevation: 10.0,
          child: Container(
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              child: Container(
                child: Stack(
                  children: <Widget>[
                    Positioned.fill(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(
                          sigmaX: 5,
                          sigmaY: 5,
                        ),
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
                    ),
                    Positioned.fill(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(
                          sigmaX: 1,
                          sigmaY: 1,
                        ),
                        child: Container(
                          color: Colors.black.withOpacity(0.4),
                          child: IconButton(
                            color: Colors.white,
                            icon: Icon(
                              Icons.play_circle_filled,
                              size: 50,
                              color: Colors.white,
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
                    ),
                    Positioned.fill(
                      child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Text(
                                      snapshot.data['camTitle'],
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                IconButton(
                                    icon: Icon(
                                      Icons.favorite_border,
                                      color: Colors.white,
                                    ),
                                    onPressed: null),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
//      appBar: AppBar(
////        flexibleSpace: Hero(
////          tag: "image${widget.selectedCategoryImage}",
////          child: CachedNetworkImage(
////            fit: BoxFit.fitWidth,
////            imageUrl: widget.selectedCategoryImage,
////            placeholder: (context, url) =>
////                Center(child: CircularProgressIndicator()),
////            errorWidget: (context, url, error) =>
////                Icon(Icons.error),
////          ),
////        ),
//        iconTheme: IconThemeData(
//            color: AppColor.kThemeColor
//        ),
//        centerTitle: true,
//        title: Text(widget.selectedCategoryTitle,style: GoogleFonts.righteous(fontSize: 20,color: AppColor.kThemeColor),),
//        backgroundColor: Color(0xff28292b),
//        actions: [
//          IconButton(
//            icon: Icon(
//              FontAwesomeIcons.searchLocation,
//              size: 25,
//            ),
//            onPressed: () {
//              Navigator.push(context,
//                  MaterialPageRoute(builder: (context) => SearchCams()));
//            },
//          ),
//          IconButton(
//              icon: Icon(
//                Icons.do_not_disturb_off,
//                color: AppColor.kThemeColor,
//                size: 25,
//              ),
//              onPressed: null),
//        ],
//      ),
        body: Center(
      child: Container(
        color: AppColor.kBackgroundColor,
        child: StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance
                .collection('maps')
                .where('category', isEqualTo: widget.selectedCategory)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Center(
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          Positioned(
                            child: Container(
                              height: 200,
                              width: MediaQuery.of(context).size.width,
                              child: CachedNetworkImage(
                                fit: BoxFit.cover,
                                imageUrl: widget.selectedCategoryImage,
                                placeholder: (context, url) => Center(
                                    child: CircularProgressIndicator()),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 50,
                            child: Container(
                              decoration: BoxDecoration(
                                  color: AppColor.kBackgroundColor,
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(20),
                                    bottomRight: Radius.circular(20),
                                  )),
                              width: 50,
                              child: IconButton(
                                icon: Icon(
                                  Icons.arrow_back_ios,
                                  color: AppColor.kThemeColor,
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                          ),
//                          Positioned(
//                            bottom: 30,
//                            child: Container(
//                              width: MediaQuery.of(context).size.width,
//                              decoration: BoxDecoration(
//                                  color: AppColor.kBackgroundColor,
//                                  borderRadius: BorderRadius.only(
//                                    topRight: Radius.circular(50),
//                                    topLeft: Radius.circular(50),
//                                  )),
//                              child: Center(
//                                child: IconButton(
//                                  icon: Icon(
//                                    Icons.timeline,
//                                    color: AppColor.kThemeColor,
//                                  ),
//                                  onPressed: () {
//                                    Navigator.pop(context);
//                                  },
//                                ),
//                              ),
//                            ),
//                          ),
                          Positioned(
                            bottom: 0,
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                  color: AppColor.kBackgroundColor,
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(50),
                                    topLeft: Radius.circular(50),
                                  )),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        widget.selectedCategoryIcon,
                                        style: GoogleFonts.righteous(
                                            fontSize: 20, color: AppColor.kThemeColor),
                                      ),
                                      SizedBox(width: 10,),
                                      Text(
                                        widget.selectedCategoryTitle,
                                        style: GoogleFonts.righteous(
                                            fontSize: 20, color: AppColor.kThemeColor),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
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
                );
              }
              else
                return Center(child: CircularProgressIndicator());
            }),
      ),
    ));
  }
}
