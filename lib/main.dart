// 🐦 Flutter imports:
import 'package:admob_flutter/admob_flutter.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';

// 🌎 Project imports:
import 'package:earth_cam/pages/splash/splash_screen.dart';

// 📦 Package imports:


void main() {
  WidgetsFlutterBinding.ensureInitialized();
//  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  Admob.initialize();
  runApp(MyApp());
//  runApp(
//      DevicePreview(
//        builder: (context) => MyApp(),
//      ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
//      locale: DevicePreview.of(context).locale,
//      builder: DevicePreview.appBuilder,
      debugShowCheckedModeBanner: false,
      title: 'Earth Cam',
      home: SplashScreen(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return HomePage();
  }
}

