
import 'package:chewie/chewie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';



class ServerVideoPlayer extends StatefulWidget {
  ServerVideoPlayer({this.url});
  final String url;


  @override
  State<StatefulWidget> createState() {
    return _ServerVideoPlayerState();
  }
}

class _ServerVideoPlayerState extends State<ServerVideoPlayer> {
  VideoPlayerController _videoPlayerController1;
  VideoPlayerController _videoPlayerController2;
  ChewieController _chewieController;
//  VideoPlayerController _controller;
  @override
  void initState() {
    super.initState();
    _videoPlayerController1 = VideoPlayerController.network(
        'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4');
    _videoPlayerController2 = VideoPlayerController.network(
        widget.url);
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController2,
      aspectRatio: 3 / 2,
      autoPlay: true,
      looping: true,
      isLive: true,
//      fullScreenByDefault: true,
      showControls: true,
      autoInitialize: true,
    );
//    _controller = VideoPlayerController.network(
//        'http://www.sample-videos.com/video123/mp4/720/big_buck_bunny_720p_20mb.mp4')
//      ..initialize().then((_) {
//        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
//        setState(() {});
//      });
  }

  @override
  void dispose() {
    _videoPlayerController1.dispose();
    _videoPlayerController2.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF1B2D45),
        centerTitle: true,
        title: Text('IP Live Cams'),
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: null),
        actions: [
          IconButton(
              icon: Icon(
                Icons.do_not_disturb_off,
                color: Colors.white,
                size: 25,
              ),
              onPressed: null),
        ],
      ),
      backgroundColor: Color(0xFF1B2D45),
      body: ListView(
        children: <Widget>[
          Stack(
            children: [
//              _controller.value.initialized
//                  ? AspectRatio(
//                aspectRatio: _controller.value.aspectRatio,
//                child: VideoPlayer(_controller),
//              )
//                  : Container(),
              Chewie(
                controller: _chewieController,
              ),
            ],
          ),
          Container(
            height: 550.0,
            child: ListView.builder(
              itemCount: 10,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ServerVideoPlayer()));
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    color: Colors.black87,
                    elevation: 10,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        const ListTile(
                          leading: Icon(
                            Icons.album,
                            size: 70,
                            color: Colors.white,
                          ),
                          title: Text('Bohemian Rhaphsody',
                              style: TextStyle(color: Colors.white)),
                          subtitle: Text('QUEEN',
                              style: TextStyle(color: Colors.white)),
                        ),
                        ButtonTheme(
                          child: ButtonBar(
                            children: <Widget>[
                              Container(
                                width: 100,
                                child: RaisedButton.icon(
                                  elevation: 12,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: new BorderRadius.circular(15),
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ServerVideoPlayer()));
                                  },
                                  icon: Icon(
                                    Icons.play_arrow,
                                    color: Colors.white,
                                  ),
                                  label: Text(
                                    'Play',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  color: Colors.red,
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}