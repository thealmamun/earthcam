import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:earth_cam/pages/category_cams.dart';
import 'package:earth_cam/pages/search_cams.dart';
import 'package:earth_cam/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neumorphic/neumorphic.dart';

class CategoryList extends StatefulWidget {
  @override
  _CategoryListState createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> with TickerProviderStateMixin{
  Stream categoryList;

  Widget _categoryList(DocumentSnapshot doc) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) {
                return CategoryCams(
                  selectedCategory: doc.data['categoryTitle'],
                  selectedCategoryTitle: doc.data['categoryTitle'],
                  selectedCategoryImage: doc.data['categoryImage'],
                  selectedCategoryIcon: doc.data['categoryIcon'],
                );
              },
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              },
            ),
          );
        },
        child: NeuCard(
          curveType: CurveType.convex,
          bevel: 10,
          decoration: NeumorphicDecoration(
              color: Color(0xff212121),
              borderRadius: BorderRadius.circular(20)),
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            child: Container(
              height: 150,
              child: Stack(
                children: <Widget>[
                  Positioned.fill(
                    child: Container(
                      color: Colors.black.withOpacity(0),
                      child: CachedNetworkImage(
                        fit: BoxFit.cover,
                        imageUrl: doc.data['categoryImage'],
                        placeholder: (context, url) =>
                            Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) =>
                            Icon(Icons.error),
                      ),
                    ),
                  ),
//                    Positioned(
//                      child: Padding(
//                        padding: const EdgeInsets.only(left:0.0),
//                        child: Row(
//                          mainAxisAlignment: MainAxisAlignment.center,
//                          crossAxisAlignment: CrossAxisAlignment.end,
//                          children: [
//                            Container(
//                              decoration: BoxDecoration(
//                                borderRadius: BorderRadius.only(
//                                    topRight: Radius.circular(20),
//                                ),
//                                color: Color(0xff3d3e40),
//                              ),
//                              child: Padding(
////                                padding: const EdgeInsets.fromLTRB(10.0,10,10,100),
//                                padding: const EdgeInsets.all(10),
//                                child: Text(
//                                  doc.data['categoryIcon'],
//                                  style: GoogleFonts.roboto(
//                                    fontSize: 30,
//                                    color: Colors.white,
//                                    letterSpacing: 3.0,
//                                  ),
//                                ),
//                              ),
//                            ),
////                            Text(
////                              doc.data['categoryIcon'],
////                              style: GoogleFonts.roboto(
////                                fontSize: 30,
////                                color: Colors.white,
////                                letterSpacing: 3.0,
////                              ),
////                            ),
//                          ],
//                        ),
//                      ),
//                    ),
                  Positioned.fill(
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 50,
                            color: Color(0xff3d3e40),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      doc.data['categoryIcon'],
                                      style: GoogleFonts.roboto(
                                        fontSize: 20,
                                        color: Colors.white,
                                        letterSpacing: 3.0,
                                      ),
                                    ),
                                  ),
                                ),
                                Text(
                                  doc.data['categoryTitle'],
                                  style: GoogleFonts.roboto(
                                    fontSize: 15,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.0,
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    alignment: Alignment.centerRight,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        doc.data['videosCount'].toString() +
                                            ' Cams',
                                        style: GoogleFonts.roboto(
                                          fontSize: 10,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
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
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    categoryList = Firestore.instance.collection('categories').snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppColor.kThemeColor),
        centerTitle: true,
        title: Text(
          'Categories',
          style:
              GoogleFonts.righteous(fontSize: 30, color: AppColor.kThemeColor),
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
                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
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
          child: StreamBuilder<QuerySnapshot>(
              stream: categoryList,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Center(
                    child: Container(
                      child: ListView(
                        children: snapshot.data.documents
                            .map((doc) => _categoryList(doc))
                            .toList(),
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
