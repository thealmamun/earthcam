import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CategoryCams extends StatefulWidget {
  @override
  _CategoryCamsState createState() => _CategoryCamsState();
}

class _CategoryCamsState extends State<CategoryCams> {
  Stream dataList;


  Widget _categoryList(DocumentSnapshot doc){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        elevation: 10.0,
        child: Container(
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            child: Container(
              height: 200,
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
                          imageUrl: doc.data['subCategoryImage'],
                          placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                          errorWidget: (context, url, error) => Icon(Icons.error),
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
                          onPressed: (){
                            print('tapped');
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
                                    doc.data['subCategoryTitle'],
                                    style: TextStyle(color: Colors.white,fontSize: 15.0,fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
//                              Expanded(
//                                child: Padding(
//                                  padding: const EdgeInsets.all(8.0),
//                                  child: Text(
//                                    snapshot.data['address'].toString(),
//                                    style: TextStyle(color: Colors.white,),
//                                  ),
//                                ),
//                              ),
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
    );
  }



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dataList = Firestore.instance.collection('categories').snapshots();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
          stream: dataList,
          builder: (context, snapshot) {
            if (snapshot.hasData) {

              List<Tab> tabs = new List<Tab>();
              for (int i = 0; i < snapshot.data.documents.length; i++) {
                tabs.add(Tab(
                  child: Container(
                    child: Text(
                      snapshot.data.documents[i]['categoryTitle'],
                      style: TextStyle(color: Colors.white, fontSize: 20.0),
                    ),
                  ),
                ));
              }

              List<Container> tabItem = new List<Container>();
              for (int i = 0; i < snapshot.data.documents.length; i++) {
//                print(snapshot.data.documents[i].documentID);
//                print(snapshot.data.documents[i]['categoryTitle']);
                tabItem.add(
                  Container(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: Firestore.instance.collection('categories').document(snapshot.data.documents[i]['categoryTitle']).collection('subcategories').snapshots(),
                      builder: (context,  snapshot) {
                        if (snapshot.hasData) {
                          return ListView(
                            children: snapshot.data.documents
                                .map((doc) => _categoryList(doc))
                                .toList(),
                          );
                        }
                        else{
                          return Center(child: CircularProgressIndicator());
                        }
                      },
                    ),
                  )
                );
              }
              return DefaultTabController(
                length: snapshot.data.documents.length,
                child: CustomScrollView(
                  slivers: <Widget>[
                    SliverAppBar(
                      centerTitle: true,
                      flexibleSpace: FlexibleSpaceBar(
                        centerTitle: true,
                        background: Image.asset(
                          'assets/images/dart.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                      title: Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[

                        ],
                      ),
                      pinned: true,
                      expandedHeight: 120.0,
                      bottom: TabBar(
                        isScrollable: true,
                        tabs: tabs,
                      ),
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
