import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:earth_cam/pages/launch_video.dart';
import 'package:earth_cam/pages/yt_video_player.dart';
import 'package:earth_cam/services/database.dart';
import 'package:flutter/material.dart';

class SearchCams extends StatefulWidget {
  @override
  _SearchCamsState createState() => _SearchCamsState();
}

class _SearchCamsState extends State<SearchCams> {

  var queryResultSet = [];
  var tempSearchStore = [];

  initiateSearch(value) {
    if (value.length == 0) {
      setState(() {
        queryResultSet = [];
        tempSearchStore = [];
      });
    }

    var capitalizedValue =
        value.substring(0, 1).toUpperCase() + value.substring(1);

    if (queryResultSet.length == 0 && value.length == 1) {
      searchByName(value).then((QuerySnapshot docs) {
        for (int i = 0; i < docs.documents.length; ++i) {
          queryResultSet.add(docs.documents[i].data);
          setState(() {
            tempSearchStore.add(queryResultSet[i]);
          });
        }
      });
    } else {
      tempSearchStore = [];
      print(tempSearchStore);
      queryResultSet.forEach((element) {
        if (element['camTitle'].toLowerCase().contains(value.toLowerCase()) ==  true) {
          if (element['camTitle'].toLowerCase().indexOf(value.toLowerCase()) ==0) {
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
      appBar: AppBar(automaticallyImplyLeading: false,),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              onChanged: (val) {
                initiateSearch(val);
              },
              decoration: InputDecoration(
                  prefixIcon: IconButton(
                    color: Colors.black,
                    icon: Icon(Icons.arrow_back),
                    iconSize: 20.0,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  contentPadding: EdgeInsets.only(left: 25.0),
                  hintText: 'Search by name',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4.0))),
            ),
          ),
          SizedBox(height: 10,),
          GridView.count(
              padding: EdgeInsets.only(left: 10.0, right: 10.0),
              crossAxisCount: 2,
              crossAxisSpacing: 4.0,
              mainAxisSpacing: 4.0,
              primary: false,
              shrinkWrap: true,
              children: tempSearchStore.map((element) {
                return buildResultCard(element);
              }).toList()),
        ],
      ),
    );
  }

  Widget buildResultCard(data){
    return GridTile(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
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
                            imageUrl: data['imageUrl'],
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
                              if(data['category'] == 'Youtube'){
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>YtVideoPlayerPage(url: data['streamUrl'],)));
                              }else{
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>LaunchVideo(url: data['streamUrl'],)));
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
                                      data['camTitle'],
                                      style: TextStyle(color: Colors.white,fontSize: 15.0,fontWeight: FontWeight.bold),
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
}
