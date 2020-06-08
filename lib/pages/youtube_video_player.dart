// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:admob_flutter/admob_flutter.dart';
import 'package:connectivity_widget/connectivity_widget.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter_native_admob/flutter_native_admob.dart';
import 'package:flutter_native_admob/native_admob_controller.dart';
import 'package:google_fonts/google_fonts.dart';

// 🌎 Project imports:
import 'package:earth_cam/services/google_admob.dart';
import 'package:earth_cam/utils/app_configure.dart';
import 'package:earth_cam/widgets/youtube_player_flutter/youtube_player_flutter.dart';
import 'package:earth_cam/utils/constants.dart';

class YtVideoPlayerPage extends StatefulWidget {
  YtVideoPlayerPage({this.url, this.title, this.imageUrl,this.check});

  final String url;
  final String title;
  final String imageUrl;
  final int check;

  @override
  _YtVideoPlayerPageState createState() => _YtVideoPlayerPageState();
}

class _YtVideoPlayerPageState extends State<YtVideoPlayerPage> {
  final _nativeAdController = NativeAdmobController();
  YoutubePlayerController _controller;
  bool hidePlayer = false;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(widget.url),
      flags: YoutubePlayerFlags(
        autoPlay: true,
        loop: true,
        isLive: true,
        enableCaption: false,
        disableDragSeek: true,
      ),
    )..addListener(() {
      if(_controller.value.hasError){
        this.onlineCallBack();
      }
    });
    hidePlayer = false;
//    FacebookAudienceNetwork.init(
//      testingId: "35e92a63-8102-46a4-b0f5-4fd269e6a13c",
//    );
//    _showAds();
//    print('Check: ${widget.check}');
    if(widget.check == 1){
      GoogleAdMob.showInterstitialAds();
    }
  }
//  _showAds() async{
//    SharedPreferences sharedPreferences;
//    sharedPreferences = await SharedPreferences.getInstance();
//    int displayTimes = sharedPreferences.getInt('counter') ?? 0;
//
//    print('DisplayTimes: $displayTimes');
//    if(displayTimes == 0){
//      GoogleAdMob.showInterstitialAds();
//    }
//    if (displayTimes == 3) {
//      displayTimes = 0;
//    }
//    else {
//      displayTimes++;
//    }
//    sharedPreferences.setInt('counter', displayTimes);
//  }


  Widget placeHolderImage(){
    return Stack(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: 200,
          child: FancyShimmerImage(
            boxFit: BoxFit.cover,
            imageUrl: widget.imageUrl,
            errorWidget: Icon(Icons.error),
          ),
        ),
        Positioned.fill(child: Center(child: CircularProgressIndicator())),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _nativeAdController.dispose();
    super.dispose();
  }

  onlineCallBack() {
    setState(() {
      _controller = YoutubePlayerController(
        initialVideoId: YoutubePlayer.convertUrlToId(widget.url),
        flags: YoutubePlayerFlags(
          autoPlay: true,
          loop: true,
          isLive: true,
          enableCaption: false,
          disableDragSeek: true,
        ),
      )..addListener(() {
        if(_controller.value.hasError){
          this.onlineCallBack();
        }
      });
      hidePlayer = false;
    });
  }

  offlineCallBack() {
    setState(() {
      _controller.pause();
      hidePlayer = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    ConnectivityUtils.initialize(
        serverToPing: "https://www.google.com",
        callback: (response) => response.contains("google"));
    Size size = MediaQuery.of(context).size;
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
      body: ConnectivityWidget(
        onlineCallback: onlineCallBack,
        offlineCallback: offlineCallBack,
        offlineBanner: Container(
          margin: EdgeInsets.only(bottom: 60),
          padding: EdgeInsets.all(8),
          width: double.infinity,
          color: Colors.red,
          child: Text(
            "No Connection. Please Check your Internet Connection.",
            style: GoogleFonts.roboto(
              fontSize: 14,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        showOfflineBanner: true,
        builder: (context, isOnline) => ListView(
          children: <Widget>[
            Stack(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: hidePlayer == false
                      ? YoutubePlayer(
                          controller: _controller,
                          showVideoProgressIndicator: false,
                          thumbnailUrl: widget.imageUrl,
                          onReady: () {
//                    _controller.addListener(listener);
                          },
                        )
                      : placeHolderImage(),
                )
              ],
            ),
            SizedBox(height: 5.0),
            Container(
              height: MediaQuery.of(context).size.height * 0.27,
              width: MediaQuery.of(context).size.width,
              child: NativeAdmob(
                adUnitID: AppConfig.nativeAddId,
                controller: _nativeAdController,
                type: NativeAdmobType.full,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: AdmobBanner(
        adUnitId: AppConfig.bannerAdId,
        adSize: AdmobBannerSize.ADAPTIVE_BANNER(
          width: size.width.toInt(),
        ),
      ),
    );
  }
}
