import 'dart:async';
import 'dart:convert';
import 'package:earth_cam/pages/server_video_player.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LiveVideosO extends StatefulWidget {
  LiveVideosO() : super();
  final String title = "Photos";


  @override
  LiveVideosOState createState() => LiveVideosOState();
}

class LiveVideosOState extends State<LiveVideosO> {
  //
  StreamController<int> streamController = new StreamController<int>();

  gridview(AsyncSnapshot<List<Album>> snapshot) {
    return Padding(
      padding: EdgeInsets.all(5.0),
      child: GridView.count(
        crossAxisCount: 2,
        childAspectRatio: 1.0,
        mainAxisSpacing: 4.0,
        crossAxisSpacing: 4.0,
        children: snapshot.data.map(
              (album) {
            return GestureDetector(
              child: GridTile(
                child: AlbumCell(context, album),
              ),
              onTap: () {
                goToDetailsPage(context, album);
              },
            );
          },
        ).toList(),
      ),
    );
  }

  goToDetailsPage(BuildContext context, Album album) {
    Navigator.push(
      context,
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (BuildContext context) => ServerVideoPlayer(
//          curAlbum: album,
        ),
      ),
    );
  }

  circularProgress() {
    return Center(
      child: const CircularProgressIndicator(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1B2D45),
      appBar: AppBar(
        centerTitle: true,
        title: Text('All Live Cams'),
        leading: IconButton(icon: Icon(Icons.arrow_back,color: Colors.white,), onPressed: null),
        actions: [
          IconButton(
              icon: Icon(
                Icons.search,
                color: Colors.white,
                size: 30,
              ),
              onPressed: null),
          IconButton(
              icon: Icon(
                Icons.do_not_disturb_off,
                color: Colors.white,
                size: 25,
              ),
              onPressed: null),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Flexible(
            child: FutureBuilder<List<Album>>(
              future: Services.getPhotos(),
              builder: (context, snapshot) {
                // not setstate here
                //
                if (snapshot.hasError) {
                  return Text('Error ${snapshot.error}');
                }
                //
                if (snapshot.hasData) {
                  streamController.sink.add(snapshot.data.length);
                  // gridview
                  return gridview(snapshot);
                }

                return circularProgress();
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    streamController.close();
    super.dispose();
  }
}



class AlbumCell extends StatelessWidget {
  const AlbumCell(this.context, this.album);
  @required
  final Album album;
  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: Container(
        constraints: new BoxConstraints.expand(
          height: 200.0,
        ),
        decoration: new BoxDecoration(
          image: new DecorationImage(
            image: new NetworkImage(album.thumbnailUrl),
            fit: BoxFit.cover,
          ),
        ),
//        alignment: Alignment.center,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Positioned(
              child: FloatingActionButton(onPressed: null,
                heroTag: null,
                backgroundColor: Colors.transparent,
                child: Icon(Icons.play_circle_filled,size: 30,color: Colors.white,),
              ),
            ),
            new Positioned(
              bottom: 0.0,
              child: Card(
                color: Colors.transparent,
                child: Container(
                  child: Row(
                    children: [
                      Column(
                        children: [
                          Text(album.title.split(" ").first,style: TextStyle(color: Colors.white),),
                          Row(
                            children: [
                              Icon(Icons.home,color: Colors.white,),
                              SizedBox(
                                width: 5,
                              ),
                              Text('Country Name',style: TextStyle(color: Colors.white),),
                            ],
                          )
                        ],
                      ),
                      IconButton(icon: Icon(Icons.favorite,color: Colors.white,), onPressed: null)
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Services {
  static Future<List<Album>> getPhotos() async {
    try {
      final response =
      await http.get("https://jsonplaceholder.typicode.com/photos");
      if (response.statusCode == 200) {
        List<Album> list = parsePhotos(response.body);
        return list;
      } else {
        throw Exception("Error");
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // Parse the JSON response and return list of Album Objects //
  static List<Album> parsePhotos(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Album>((json) => Album.fromJson(json)).toList();
  }
}

class Album {
  int albumId;
  int id;
  String title;
  String url;
  String thumbnailUrl;

  Album({this.albumId, this.id, this.title, this.url, this.thumbnailUrl});

  // Return object from JSON //
  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
        albumId: json['albumId'] as int,
        id: json['id'] as int,
        title: json['title'] as String,
        url: json['url'] as String,
        thumbnailUrl: json['thumbnailUrl'] as String);
  }
}

class GridDetails extends StatefulWidget {
  final Album curAlbum;
  GridDetails({@required this.curAlbum});

  @override
  GridDetailsState createState() => GridDetailsState();
}

class GridDetailsState extends State<GridDetails> {
  //
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Hero(
              tag: "image${widget.curAlbum.id}",
              child: FadeInImage.assetNetwork(
                placeholder: "assets/images/cctv5.png",
                image: widget.curAlbum.url,
              ),
            ),
            SizedBox(
              height: 30.0,
            ),
            OutlineButton(
              child: Icon(Icons.close),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
    );
  }
}
