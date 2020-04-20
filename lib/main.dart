import 'package:earth_cam/TestPage.dart';
import 'package:earth_cam/TestPage2.dart';
import 'package:earth_cam/pages/server_video_player.dart';
import 'package:earth_cam/pages/yt_video_player.dart';
import 'package:earth_cam/splash/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
//  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Earth Cam',
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SplashScreen();
  }
}

