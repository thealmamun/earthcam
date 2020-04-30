import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:earth_cam/pages/launch_video.dart';
import 'package:earth_cam/pages/search_cams.dart';
import 'package:earth_cam/pages/yt_video_player.dart';
import 'package:earth_cam/utils/constants.dart';
import 'package:earth_cam/widgets/cams_grid_tile.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neumorphic/neumorphic.dart';

class CategoryCams extends StatefulWidget {
  CategoryCams(
      {this.selectedCategory,
      this.selectedCategoryTitle,
      this.selectedCategoryImage,
      this.selectedCategoryIcon});

  final String selectedCategory;
  final String selectedCategoryTitle;
  final String selectedCategoryImage;
  final String selectedCategoryIcon;

  @override
  _CategoryCamsState createState() => _CategoryCamsState();
}

class _CategoryCamsState extends State<CategoryCams> {
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                            Positioned(
                              bottom: 0,
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                height: 60,
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          widget.selectedCategoryIcon,
                                          style: GoogleFonts.righteous(
                                              fontSize: 20,
                                              color: AppColor.kThemeColor),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          widget.selectedCategoryTitle,
                                          style: GoogleFonts.righteous(
                                              fontSize: 20,
                                              color: AppColor.kThemeColor),
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
                } else
                  return Center(child: CircularProgressIndicator());
              }),
        ),
      ),
    );
  }
}
