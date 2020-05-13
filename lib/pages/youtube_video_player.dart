import 'package:earth_cam/utils/app_configure.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_admob/flutter_native_admob.dart';
import 'package:flutter_native_admob/native_admob_controller.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:earth_cam/utils/constants.dart';

class YtVideoPlayerPage extends StatefulWidget {
  YtVideoPlayerPage({this.url, this.title});

  final String url;
  final String title;

  @override
  _YtVideoPlayerPageState createState() => _YtVideoPlayerPageState();
}

class _YtVideoPlayerPageState extends State<YtVideoPlayerPage> {
  final _nativeAdController = NativeAdmobController();

  YoutubePlayerController _controller;

  @override
  void initState() {
    _controller = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(widget.url),
      flags: YoutubePlayerFlags(
        autoPlay: true,
        loop: true,
        isLive: true,
        enableCaption: false,
        hideControls: false,
      ),
    );

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
//    _subscription.cancel();
    _nativeAdController.dispose();
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
              YoutubePlayer(
                controller: _controller,
                showVideoProgressIndicator: true,
                progressIndicatorColor: Colors.blueAccent,
                onReady: () {
                  print('Player is ready.');
                },
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
