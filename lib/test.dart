// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:connectivity_widget/connectivity_widget.dart';
import 'package:video_player/video_player.dart';

// 🌎 Project imports:
import 'package:earth_cam/widgets/chewie_player_custom/src/chewie_player.dart';
import 'package:wakelock/wakelock.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //setup connectivity server to ping and callback
    ConnectivityUtils.initialize(
        serverToPing:
        "https://gist.githubusercontent.com/Vanethos/dccc4b4605fc5c5aa4b9153dacc7391c/raw/355ccc0e06d0f84fdbdc83f5b8106065539d9781/gistfile1.txt",
        callback: (response) => response.contains("This is a test!"));

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Connectivity Widget Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  VideoPlayerController _videoPlayerController2;
  ChewieController _chewieController;
//  String url = 'http://videostream.shockmedia.com.ar:1935/lacostadigital/lacostadigital/chunklist_w772978448.m3u8';
  String url = 'https://livecdn-de-earthtv-com.global.ssl.fastly.net/edge0/cdnedge/H1d0HWSABMI/chunklist.m3u8?token=EAIYzgM4-YGAJECgOEgF.CgtpYml6YXN0eWxlcxABMgtIMWQwSFZlQUJNQToLSDFkMEhXU0FCTUk.THXPBT6WKd8oEH8mSXtQjbCn4xwuNlWdYrWgUjBz87TjDqup5WqzfS8ou8G5zVQucwb-HERihVelH68Nw7nglw&domain=worldcams.tv';

  void _incrementCounter() {
    setState(() {
      _counter++;
      _videoPlayerController2 = VideoPlayerController.network(url);

      _videoPlayerController2.addListener(() {
        if (_videoPlayerController2.value.hasError) {
          this._incrementCounter();
        }
      });
      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController2,
        showControlsOnInitialize: false,
        aspectRatio: 16 / 9,
        autoPlay: true,
        looping: true,
        isLive: true,
        fullScreenByDefault: false,
        autoInitialize: true,
      );
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _videoPlayerController2 = VideoPlayerController.network(url);

    _videoPlayerController2.addListener(() {
      if (_videoPlayerController2.value.hasError) {
        this._incrementCounter();
      }
    });
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController2,
      showControlsOnInitialize: false,
      aspectRatio: 16 / 9,
      autoPlay: true,
      looping: true,
      isLive: true,
      fullScreenByDefault: false,
      autoInitialize: true,
        errorBuilder: (context, errorMessage) {
          return Center(
            child: Text(
              errorMessage,
              style: TextStyle(color: Colors.white),
            ),
          );
        }
    );
    Wakelock.enable();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ConnectivityWidget(
        onlineCallback: _incrementCounter,
        builder: (context, isOnline) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Chewie(
                controller: _chewieController,
              ),
              Text(
                "${isOnline ? 'Online' : 'Offline'}",
                style: TextStyle(
                    fontSize: 30, color: isOnline ? Colors.green : Colors.red),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'Number of times we connected to the internet:',
              ),
              Text(
                '$_counter',
                style: Theme.of(context).textTheme.headline4,
              ),
            ],
          ),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
