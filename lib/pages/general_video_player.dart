import 'package:chewie/chewie.dart';
import 'package:earth_cam/utils/app_configure.dart';
import 'package:earth_cam/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_admob/flutter_native_admob.dart';
import 'package:flutter_native_admob/native_admob_controller.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';

class ServerVideoPlayer extends StatefulWidget {
  ServerVideoPlayer({this.url, this.title});

  final String url;
  final String title;

  @override
  State<StatefulWidget> createState() {
    return _ServerVideoPlayerState();
  }
}

class _ServerVideoPlayerState extends State<ServerVideoPlayer> {
  VideoPlayerController _videoPlayerController2;
  ChewieController _chewieController;

  final _nativeAdController = NativeAdmobController();

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
    _videoPlayerController2 = VideoPlayerController.network(widget.url);

    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController2,
      showControlsOnInitialize: false,
      aspectRatio: 16 / 9,
      autoPlay: true,
      looping: true,
      isLive: true,
      fullScreenByDefault: false,
      autoInitialize: false,
    );
  }

  @override
  void dispose() {
    _chewieController.dispose();
    _videoPlayerController2.dispose();
    _nativeAdController.dispose();
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
        actions: [],
      ),
      backgroundColor: AppColor.kBackgroundColor,
      body: ListView(
        children: <Widget>[
          Stack(
            children: [
              Chewie(
                controller: _chewieController,
              ),
            ],
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.3,
            width: MediaQuery.of(context).size.width,
            color: AppColor.kAppBarBackgroundColor,
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.only(bottom: 20.0),
            child: NativeAdmob(
              // Your ad unit id
              adUnitID: AppConfig.adUnitID,
              controller: _nativeAdController,
              type: NativeAdmobType.full,
            ),
          ),
        ],
      ),
    );
  }
}
