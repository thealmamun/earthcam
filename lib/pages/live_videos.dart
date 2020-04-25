import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:earth_cam/model/cams.dart';
import 'package:flutter/material.dart';

class LiveVideos extends StatefulWidget {
  @override
  _LiveVideosState createState() => _LiveVideosState();
}

class _LiveVideosState extends State<LiveVideos> {
  Widget _mapList(DocumentSnapshot snapshot) {
    return GridTile(
      child: Card(
        color: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: CachedNetworkImageProvider(
                snapshot.data['imageUrl'],
              ),
            ),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
//              CachedNetworkImage(
//                fit: BoxFit.cover,
//                imageUrl: snapshot.data['imageUrl'],
//                placeholder: (context, url) => CircularProgressIndicator(),
//                errorWidget: (context, url, error) => Icon(Icons.error),
//              ),
              Positioned(
                child: FloatingActionButton(
                  onPressed: null,
                  heroTag: null,
                  backgroundColor: Colors.transparent,
                  child: Icon(
                    Icons.play_circle_filled,
                    size: 30,
                    color: Colors.white,
                  ),
                ),
              ),
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(
                          snapshot.data['camTitle'],
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              snapshot.data['address'],
                              style: TextStyle(color: Colors.black),
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
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance.collection('maps').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return GridView.count(
                crossAxisCount: 2,
                childAspectRatio: 1.0,
                mainAxisSpacing: 4.0,
                crossAxisSpacing: 4.0,
                children: snapshot.data.documents
                    .map((doc) => _mapList(doc))
                    .toList(),
              );
            } else
              return Center(child: CircularProgressIndicator());
          }),
    );
  }
}
