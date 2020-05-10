import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:earth_cam/utils/constants.dart';

class YtVideoPlayerPage extends StatefulWidget {
  YtVideoPlayerPage({this.url,this.title});
  final String url;
  final String title;
  @override
  _YtVideoPlayerPageState createState() => _YtVideoPlayerPageState();
}

class _YtVideoPlayerPageState extends State<YtVideoPlayerPage> {

  YoutubePlayerController _controller;

  @override
  void initState() {
    _controller = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(widget.url),
      flags: YoutubePlayerFlags(
//        mute: false,
        autoPlay: true,
//        disableDragSeek: false,
        loop: true,
        isLive: true,

//        forceHideAnnotation: true,
//        forceHD: false,
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
//          Container(
//            height: 450.0,
//            child: ListView.builder(
//              itemCount: 10,
//              itemBuilder: (context, index) {
//                return GestureDetector(
//                  onTap: () {
//                    Navigator.push(
//                        context,
//                        MaterialPageRoute(
//                            builder: (context) => YtVideoPlayerPage()));
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
    );
  }
}

//TEST# 1
////import 'package:earth_cam/pages/live_videos-o.dart';
////import 'package:flutter/cupertino.dart';
////import 'package:flutter/material.dart';
////import 'package:flutter/rendering.dart';
////import 'package:flutter/services.dart';
////import 'package:youtube_player_flutter/youtube_player_flutter.dart';
////
////void main() {
////  WidgetsFlutterBinding.ensureInitialized();
////  SystemChrome.setSystemUIOverlayStyle(
////    SystemUiOverlayStyle(
////      statusBarColor: Colors.blueAccent,
////    ),
////  );
////  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
////  runApp(YoutubePlayerDemoApp());
////}
////
//import 'package:earth_cam/pages/search_cams.dart';
//import 'package:earth_cam/pages/general_video_player.dart';
//import 'package:earth_cam/utils/constants.dart';
//
/////// Creates [YoutubePlayerDemoApp] widget.
////
////class YtVideoPlayerPage extends StatelessWidget {
////  @override
////  Widget build(BuildContext context) {
////    return MaterialApp(
////      debugShowCheckedModeBanner: false,
////      title: 'Youtube Player Flutter',
////      theme: ThemeData(
////        primarySwatch: Colors.blue,
////        appBarTheme: AppBarTheme(
////          color: Colors.blueAccent,
////          textTheme: TextTheme(
////            // ignore: deprecated_member_use
////            title: TextStyle(
////              color: Colors.white,
////              fontWeight: FontWeight.w300,
////              fontSize: 20.0,
////            ),
////          ),
////        ),
////        iconTheme: IconThemeData(
////          color: Colors.blueAccent,
////        ),
////      ),
////      home: MyHomePage(),
////    );
////  }
////}
////
/////// Homepage
////class YtVideoPlayerPage extends StatefulWidget {
////  @override
////  _YtVideoPlayerPageState createState() => _YtVideoPlayerPageState();
////}
////
////class _YtVideoPlayerPageState extends State<YtVideoPlayerPage> {
////  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
////  YoutubePlayerController _controller;
////  TextEditingController _idController;
////  TextEditingController _seekToController;
////
////  PlayerState _playerState;
////  YoutubeMetaData _videoMetaData;
////  double _volume = 100;
////  bool _muted = false;
////  bool _isPlayerReady = false;
////
////  final List<String> _ids = [
////    'nPt8bK2gbaU',
////    'qiYKD1FZ5YM',
////    'gQDByCdjUXw',
////    'iLnmTe5Q2Qw',
////    '_WoCV4c6XOE',
////    'KmzdUe0RSJo',
////    '6jZDSSZZxjQ',
////    'p2lYr3vM_1w',
////    '7QUtEmBT_-w',
////    '34_PXCzGw1M',
////  ];
////
////  @override
////  void initState() {
////    super.initState();
////    _controller = YoutubePlayerController(
////      initialVideoId: _ids.first,
////      flags: YoutubePlayerFlags(
////        mute: false,
////        autoPlay: true,
////        disableDragSeek: false,
////        loop: false,
////        isLive: true,
////        forceHideAnnotation: true,
////        forceHD: false,
////        enableCaption: true,
////        hideControls: true,
////      ),
////    )..addListener(listener);
////    _idController = TextEditingController();
////    _seekToController = TextEditingController();
////    _videoMetaData = YoutubeMetaData();
////    _playerState = PlayerState.unknown;
////  }
////
////  void listener() {
////    if (_isPlayerReady && mounted && !_controller.value.isFullScreen) {
////      setState(() {
////        _playerState = _controller.value.playerState;
////        _videoMetaData = _controller.metadata;
////      });
////    }
////  }
////
////  @override
////  void deactivate() {
////    // Pauses video while navigating to next page.
////    _controller.pause();
////    super.deactivate();
////  }
////
////  @override
////  void dispose() {
////    _controller.dispose();
////    _idController.dispose();
////    _seekToController.dispose();
////    super.dispose();
////  }
////
////  @override
////  Widget build(BuildContext context) {
////    return Scaffold(
////      key: _scaffoldKey,
////      body: ListView(
////        children: [
////          YoutubePlayer(
////            controller: _controller,
////            showVideoProgressIndicator: true,
////            progressIndicatorColor: Colors.blueAccent,
////            topActions: <Widget>[
////              SizedBox(width: 8.0),
////              Expanded(
////                child: Text(
////                  _controller.metadata.title,
////                  style: TextStyle(
////                    color: Colors.white,
////                    fontSize: 18.0,
////                  ),
////                  overflow: TextOverflow.ellipsis,
////                  maxLines: 1,
////                ),
////              ),
//////              IconButton(
//////                icon: Icon(
//////                  Icons.settings,
//////                  color: Colors.white,
//////                  size: 25.0,
//////                ),
//////                onPressed: () {
//////                  _showSnackBar('Settings Tapped!');
//////                },
//////              ),
////            ],
////            onReady: () {
////              _isPlayerReady = true;
////            },
////            onEnded: (data) {
////              _controller.load(_ids[(_ids.indexOf(data.videoId) + 1) % _ids.length]);
////              _showSnackBar('Next Video Started!');
////            },
////          ),
//////          Padding(
//////            padding: EdgeInsets.all(8.0),
//////            child: Column(
//////              crossAxisAlignment: CrossAxisAlignment.stretch,
//////              children: [
//////                _space,
//////                _text('Title', _videoMetaData.title),
//////                _space,
//////                _text('Channel', _videoMetaData.author),
//////                _space,
//////                _text('Video Id', _videoMetaData.videoId),
//////                _space,
//////                Row(
//////                  children: [
//////                    _text(
//////                      'Playback Quality',
//////                      _controller.value.playbackQuality,
//////                    ),
//////                    Spacer(),
//////                    _text(
//////                      'Playback Rate',
//////                      '${_controller.value.playbackRate}x  ',
//////                    ),
//////                  ],
//////                ),
//////                _space,
//////                TextField(
//////                  enabled: _isPlayerReady,
//////                  controller: _idController,
//////                  decoration: InputDecoration(
//////                    border: InputBorder.none,
//////                    hintText: 'Enter youtube \<video id\> or \<link\>',
//////                    fillColor: Colors.blueAccent.withAlpha(20),
//////                    filled: true,
//////                    hintStyle: TextStyle(
//////                      fontWeight: FontWeight.w300,
//////                      color: Colors.blueAccent,
//////                    ),
//////                    suffixIcon: IconButton(
//////                      icon: Icon(Icons.clear),
//////                      onPressed: () => _idController.clear(),
//////                    ),
//////                  ),
//////                ),
//////                _space,
//////                Row(
//////                  children: [
//////                    _loadCueButton('LOAD'),
//////                    SizedBox(width: 10.0),
//////                    _loadCueButton('CUE'),
//////                  ],
//////                ),
//////                _space,
//////                Row(
//////                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//////                  children: [
//////                    IconButton(
//////                      icon: Icon(Icons.skip_previous),
//////                      onPressed: _isPlayerReady
//////                          ? () => _controller.load(_ids[(_ids.indexOf(_controller.metadata.videoId) - 1) % _ids.length])
//////                          : null,
//////                    ),
//////                    IconButton(
//////                      icon: Icon(
//////                        _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
//////                      ),
//////                      onPressed: _isPlayerReady
//////                          ? () {
//////                        _controller.value.isPlaying ? _controller.pause() : _controller.play();
//////                        setState(() {});
//////                      }
//////                          : null,
//////                    ),
//////                    IconButton(
//////                      icon: Icon(_muted ? Icons.volume_off : Icons.volume_up),
//////                      onPressed: _isPlayerReady
//////                          ? () {
//////                        _muted ? _controller.unMute() : _controller.mute();
//////                        setState(() {
//////                          _muted = !_muted;
//////                        });
//////                      }
//////                          : null,
//////                    ),
//////                    FullScreenButton(
//////                      controller: _controller,
//////                      color: Colors.blueAccent,
//////                    ),
//////                    IconButton(
//////                      icon: Icon(Icons.skip_next),
//////                      onPressed: _isPlayerReady
//////                          ? () => _controller.load(_ids[(_ids.indexOf(_controller.metadata.videoId) + 1) % _ids.length])
//////                          : null,
//////                    ),
//////                  ],
//////                ),
//////                _space,
//////                Row(
//////                  children: <Widget>[
//////                    Text(
//////                      "Volume",
//////                      style: TextStyle(fontWeight: FontWeight.w300),
//////                    ),
//////                    Expanded(
//////                      child: Slider(
//////                        inactiveColor: Colors.transparent,
//////                        value: _volume,
//////                        min: 0.0,
//////                        max: 100.0,
//////                        divisions: 10,
//////                        label: '${(_volume).round()}',
//////                        onChanged: _isPlayerReady
//////                            ? (value) {
//////                          setState(() {
//////                            _volume = value;
//////                          });
//////                          _controller.setVolume(_volume.round());
//////                        }
//////                            : null,
//////                      ),
//////                    ),
//////                  ],
//////                ),
//////                _space,
//////                AnimatedContainer(
//////                  duration: Duration(milliseconds: 800),
//////                  decoration: BoxDecoration(
//////                    borderRadius: BorderRadius.circular(20.0),
//////                    color: _getStateColor(_playerState),
//////                  ),
//////                  padding: EdgeInsets.all(8.0),
//////                  child: Text(
//////                    _playerState.toString(),
//////                    style: TextStyle(
//////                      fontWeight: FontWeight.w300,
//////                      color: Colors.white,
//////                    ),
//////                    textAlign: TextAlign.center,
//////                  ),
//////                ),
//////              ],
//////            ),
//////          ),
////        ],
////      ),
////    );
////  }
////
////  Widget _text(String title, String value) {
////    return RichText(
////      text: TextSpan(
////        text: '$title : ',
////        style: TextStyle(
////          color: Colors.blueAccent,
////          fontWeight: FontWeight.bold,
////        ),
////        children: [
////          TextSpan(
////            text: value ?? '',
////            style: TextStyle(
////              color: Colors.blueAccent,
////              fontWeight: FontWeight.w300,
////            ),
////          ),
////        ],
////      ),
////    );
////  }
////
////  Color _getStateColor(PlayerState state) {
////    switch (state) {
////      case PlayerState.unknown:
////        return Colors.grey[700];
////      case PlayerState.unStarted:
////        return Colors.pink;
////      case PlayerState.ended:
////        return Colors.red;
////      case PlayerState.playing:
////        return Colors.blueAccent;
////      case PlayerState.paused:
////        return Colors.orange;
////      case PlayerState.buffering:
////        return Colors.yellow;
////      case PlayerState.cued:
////        return Colors.blue[900];
////      default:
////        return Colors.blue;
////    }
////  }
////
////  Widget get _space => SizedBox(height: 10);
////
////  Widget _loadCueButton(String action) {
////    return Expanded(
////      child: MaterialButton(
////        color: Colors.blueAccent,
////        onPressed: _isPlayerReady
////            ? () {
////          if (_idController.text.isNotEmpty) {
////            var id = YoutubePlayer.convertUrlToId(
////              _idController.text,
////            );
////            if (action == 'LOAD') _controller.load(id);
////            if (action == 'CUE') _controller.cue(id);
////            FocusScope.of(context).requestFocus(FocusNode());
////          } else {
////            _showSnackBar('Source can\'t be empty!');
////          }
////        }
////            : null,
////        disabledColor: Colors.grey,
////        disabledTextColor: Colors.black,
////        child: Padding(
////          padding: const EdgeInsets.symmetric(vertical: 14.0),
////          child: Text(
////            action,
////            style: TextStyle(
////              fontSize: 18.0,
////              color: Colors.white,
////              fontWeight: FontWeight.w300,
////            ),
////            textAlign: TextAlign.center,
////          ),
////        ),
////      ),
////    );
////  }
////
////  void _showSnackBar(String message) {
////    _scaffoldKey.currentState.showSnackBar(
////      SnackBar(
////        content: Text(
////          message,
////          textAlign: TextAlign.center,
////          style: TextStyle(
////            fontWeight: FontWeight.w300,
////            fontSize: 16.0,
////          ),
////        ),
////        backgroundColor: Colors.blueAccent,
////        behavior: SnackBarBehavior.floating,
////        elevation: 1.0,
////        shape: RoundedRectangleBorder(
////          borderRadius: BorderRadius.circular(50.0),
////        ),
////      ),
////    );
////  }
////}
//TEST #2
//import 'package:flutter/material.dart';
//import 'package:flutter_youtube_view/flutter_youtube_view.dart';
//
//class YtVideoPlayerPage extends StatefulWidget {
//    YtVideoPlayerPage({this.url});
//  final String url;
//  @override
//  _YtVideoPlayerPageState createState() => _YtVideoPlayerPageState();
//}
//
//class _YtVideoPlayerPageState extends State<YtVideoPlayerPage>
//    implements YouTubePlayerListener {
//  double _currentVideoSecond = 0.0;
//  String _playerState = "";
//  FlutterYoutubeViewController _controller;
//
//  @override
//  void onCurrentSecond(double second) {
//    print("onCurrentSecond second = $second");
//    _currentVideoSecond = second;
//  }
//
//  @override
//  void onError(String error) {
//    print("onError error = $error");
//  }
//
//  @override
//  void onReady() {
//    print("onReady");
//  }
//
//  @override
//  void onStateChange(String state) {
//    print("onStateChange state = $state");
//    setState(() {
//      _playerState = state;
//    });
//  }
//
//  @override
//  void onVideoDuration(double duration) {
//    print("onVideoDuration duration = $duration");
//  }
//
//  void _onYoutubeCreated(FlutterYoutubeViewController controller) {
//    this._controller = controller;
//  }
//
//  void _loadOrCueVideo() {
//    _controller.loadOrCueVideo(widget.url, _currentVideoSecond);
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//        appBar: AppBar(title: const Text('Default UI')),
//        body: Stack(
//          children: <Widget>[
//            Container(
//                child: FlutterYoutubeView(
//                  onViewCreated: _onYoutubeCreated,
//                  listener: this,
//                  params: YoutubeParam(
//                    videoId: widget.url,
//                    showUI: true,
//                    startSeconds: 5 * 60.0,
//                    showYoutube: false,
//                    showFullScreen: false,
//                  ),
//                )),
//            Center(
//                child: Column(
//                  children: <Widget>[
//                    Text(
//                      'Current state: $_playerState',
//                      style: TextStyle(color: Colors.blue),
//                    ),
//                    RaisedButton(
//                      onPressed: _loadOrCueVideo,
//                      child: Text('Click reload video'),
//                    ),
//                  ],
//                ))
//          ],
//        ));
//  }
//}
