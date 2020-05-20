// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:connectivity_widget/connectivity_widget.dart';
import 'package:video_player/video_player.dart';

// 🌎 Project imports:
import 'package:earth_cam/widgets/chewie_player_custom/src/chewie_player.dart';

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

  void _incrementCounter() {
    setState(() {
      _counter++;
      _videoPlayerController2 = VideoPlayerController.network('https://itpolly.iptv.digijadoo.net/live/btv_world/chunks.m3u8');
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
    _videoPlayerController2 = VideoPlayerController.network('https://itpolly.iptv.digijadoo.net/live/btv_world/chunks.m3u8');
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
