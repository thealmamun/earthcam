import 'package:chewie/chewie.dart';
import 'package:earth_cam/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';



class ServerVideoPlayer extends StatefulWidget {
  ServerVideoPlayer({this.url,this.title});
  final String url;
  final String title;


  @override
  State<StatefulWidget> createState() {
    return _ServerVideoPlayerState();
  }
}

class _ServerVideoPlayerState extends State<ServerVideoPlayer> {
//  VideoPlayerController _videoPlayerController1;
  VideoPlayerController _videoPlayerController2;
  ChewieController _chewieController;
//  var headers = {"t":"20.174.223","n":"1.262"};
//  var headers = {"t":"1.323.324","n":"58"};

//  getRes() async {
//    var response =
//    await http.get('https://static.skylinewebcams.com/286.json');
//    print(response.body);
//    return response;
//  }
//  getVideo() {
//    print('here');
////    await getRes();
//    _controller =  VideoPlayerController.network(
//        widget.url
//    )..initialize().then((_) {
//      setState(() {});
//    });
//  }
  @override
  void initState() {
    super.initState();
//    getVideo();
//    _videoPlayerController1 = VideoPlayerController.network(
//        'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4');
//    getVideo();
    _videoPlayerController2 = VideoPlayerController.network(
        widget.url);

    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController2,
      showControlsOnInitialize: false,
      aspectRatio: 16 / 9,
      autoPlay: true,
      looping: true,
      isLive: true,
      fullScreenByDefault: true,
//      showControls: true,
      autoInitialize: false,
    );
//    _controller = VideoPlayerController.network(
//        'https://www.sample-videos.com/video123/mp4/720/big_buck_bunny_720p_20mb.mp4')
//      ..initialize().then((_) {
//        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
//        setState(() {});
//      });
//    _controller = VideoPlayerController.network(
//        widget.url)..initialize().then((_) {
//      // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
//      setState(() {});
//    });
  }

  @override
  void dispose() {
//    _videoPlayerController1.dispose();
//    _chewieController.dispose();
    _chewieController.dispose();
    _videoPlayerController2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 10,
        iconTheme: IconThemeData(color: AppColor.kThemeColor),
        centerTitle: true,
        title: SizedBox(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              widget.title,
              style: GoogleFonts.righteous(
                  fontSize: 20, color: AppColor.kThemeColor),
            ),
          ),
        ),
        backgroundColor: AppColor.kAppBarBackgroundColor,
        actions: [

        ],
      ),
      backgroundColor: AppColor.kBackgroundColor,
      body: ListView(
        children: <Widget>[
          Stack(
            children: [
//              _controller.value.initialized
//                  ? AspectRatio(
//                aspectRatio: _controller.value.aspectRatio,
//                child: VideoPlayer(_controller),
//              )
//                  : Container(child: Text('aa'),)
              Chewie(
                controller: _chewieController,
              ),
            ],
          ),
//          Container(
//            height: 550.0,
//            child: ListView.builder(
//              itemCount: 10,
//              itemBuilder: (context, index) {
//                return GestureDetector(
//                  onTap: () {
//                    Navigator.push(
//                        context,
//                        MaterialPageRoute(
//                            builder: (context) => ServerVideoPlayer()));
//                  },
//                  child: Card(
//                    shape: RoundedRectangleBorder(
//                      borderRadius: BorderRadius.circular(15.0),
//                    ),
//                    color: Colors.black87,
//                    elevation: 10,
//                    child: Column(
//                      mainAxisSize: MainAxisSize.min,
//                      children: <Widget>[
//                        const ListTile(
//                          leading: Icon(
//                            Icons.album,
//                            size: 70,
//                            color: Colors.white,
//                          ),
//                          title: Text('Bohemian Rhaphsody',
//                              style: TextStyle(color: Colors.white)),
//                          subtitle: Text('QUEEN',
//                              style: TextStyle(color: Colors.white)),
//                        ),
//                        ButtonTheme(
//                          child: ButtonBar(
//                            children: <Widget>[
//                              Container(
//                                width: 100,
//                                child: RaisedButton.icon(
//                                  elevation: 12,
//                                  shape: RoundedRectangleBorder(
//                                    borderRadius: new BorderRadius.circular(15),
//                                  ),
//                                  onPressed: () {
//                                    Navigator.push(
//                                        context,
//                                        MaterialPageRoute(
//                                            builder: (context) =>
//                                                ServerVideoPlayer()));
//                                  },
//                                  icon: Icon(
//                                    Icons.play_arrow,
//                                    color: Colors.white,
//                                  ),
//                                  label: Text(
//                                    'Play',
//                                    style: TextStyle(color: Colors.white),
//                                  ),
//                                  color: Colors.red,
//                                ),
//                              )
//                            ],
//                          ),
//                        ),
//                      ],
//                    ),
//                  ),
//                );
//              },
//            ),
//          ),
        ],
      ),
//      floatingActionButton: FloatingActionButton(
//        onPressed: () {
//          setState(() {
//            _controller.value.isPlaying
//                ? _controller.pause()
//                : _controller.play();
//          });
//        },
//        child: Icon(
//          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
//        ),
//      ),
    );
  }
}
