import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:earth_cam/pages/category_cams.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CategoryList extends StatefulWidget {
  @override
  _CategoryListState createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  Stream categoryList;

  Widget _categoryList(DocumentSnapshot doc) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (context,animation,secondaryAnimation){
                  return CategoryCams(
                    selectedCategory: doc.data['categoryTitle'],
                    selectedCategoryTitle:doc.data['categoryTitle'],
                    selectedCategoryImage: doc.data['categoryImage'],
                  );
                },
                transitionsBuilder: (context,animation,secondaryAnimation,child){
                  return ScaleTransition(
                    scale: animation,
                    child: child,
                  );
                }
              ));
        },
        child: Material(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          elevation: 10.0,
          child: Container(
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              child: Container(
                height: 150,
                child: Stack(
                  children: <Widget>[
                    Positioned.fill(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(
                          sigmaX: 1,
                          sigmaY: 1,
                        ),
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
                    ),
                    Positioned.fill(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(
                          sigmaX: 1,
                          sigmaY: 1,
                        ),
                        child: Container(
                          color: Colors.black.withOpacity(0.4),
                        ),
                      ),
                    ),
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(doc.data['categoryIcon'],
                              style: GoogleFonts.robotoSlab(
                                fontSize: 40, color: Colors.white,
                                letterSpacing: 3.0,
                              ),
                            ),
                            Expanded(
                              child: Container(
                                alignment: Alignment.topRight,
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Text(doc.data['videosCount'].toString()+' Cams',
                                    style: GoogleFonts.robotoSlab(
                                      fontSize: 18, color: Colors.white,
                                      letterSpacing: 3.0,
                                    ),
                                  ),
                                ),
                              ),
                            ),
//                            Expanded(
//                              child: Container(
//                                alignment: Alignment.topRight,
//                                child: Padding(
//                                  padding: const EdgeInsets.all(12.0),
//                                  child: Container(
//                                    height: 50.0,
//                                    alignment: Alignment.topRight,
//                                    child: RaisedButton(
//                                      onPressed: () {},
//                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
//                                      padding: EdgeInsets.all(0.0),
//                                      child: Ink(
//                                        decoration: BoxDecoration(
//                                            gradient: LinearGradient(colors: [Color(0xff374ABE), Color(0xff64B6FF)],
//                                              begin: Alignment.centerLeft,
//                                              end: Alignment.centerRight,
//                                            ),
//                                            borderRadius: BorderRadius.circular(30.0)
//                                        ),
//                                        child: Container(
//                                          constraints: BoxConstraints(maxWidth: 100.0, minHeight: 50.0),
//                                          alignment: Alignment.center,
//                                          child: Text(
//                                            "View",
//                                            textAlign: TextAlign.center,
//                                            style: TextStyle(
//                                                color: Colors.white
//                                            ),
//                                          ),
//                                        ),
//                                      ),
//                                    ),
//                                  ),
//                                ),
//                              ),
//                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Container(
                              alignment: Alignment.bottomLeft,
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Text(doc.data['categoryTitle'],
                                  style: GoogleFonts.robotoSlab(
                                    fontSize: 20, color: Colors.white,
                                    letterSpacing: 2.0,
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
      body: StreamBuilder<QuerySnapshot>(
          stream: categoryList,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Tab> tabs = new List<Tab>();
              for (int i = 0; i < snapshot.data.documents.length; i++) {
                tabs.add(Tab(
                  child: Container(
                    child: Text(
                      snapshot.data.documents[i]['categoryTitle'],
                      style: GoogleFonts.robotoSlab(
                          fontSize: 20, color: Colors.white),
                    ),
                  ),
                ));
              }
              List<Container> tabItem = new List<Container>();
              for (int i = 0; i < snapshot.data.documents.length; i++) {
                tabItem.add(Container(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: Firestore.instance
                        .collection('categories')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return ListView(
                          children: snapshot.data.documents
                              .map((doc) => _categoryList(doc))
                              .toList(),
                        );
                      } else {
                        return Center(child: CircularProgressIndicator());
                      }
                    },
                  ),
                ));
              }
              return DefaultTabController(
                length: snapshot.data.documents.length,
                child: CustomScrollView(
                  slivers: <Widget>[
                    SliverAppBar(
                      automaticallyImplyLeading: false,
                      centerTitle: true,
                      flexibleSpace: FlexibleSpaceBar(
                        centerTitle: true,
                        background: Image.asset(
                          'assets/images/dart.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                      title: Text(
                        'Category',
                        style: GoogleFonts.robotoSlab(
                            fontSize: 30, color: Colors.white),
                      ),
                      pinned: true,
                      expandedHeight: 60.0,
//                      bottom: TabBar(
//                        isScrollable: true,
//                        tabs: tabs,
//                      ),
                    ),
                    SliverFillRemaining(
                      child: TabBarView(
                        children: tabItem,
                      ),
                    ),
                  ],
                ),
              );
            } else
              return Center(child: CircularProgressIndicator());
          }),
    );
  }
}
