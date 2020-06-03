// 🐦 Flutter imports:
import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';

// 🌎 Project imports:
import 'package:earth_cam/pages/splash/splash_screen.dart';
import 'package:flutter/services.dart';
import 'package:wakelock/wakelock.dart';

// 📦 Package imports:


void main() {
  WidgetsFlutterBinding.ensureInitialized();
//  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  Admob.initialize(testDeviceIds: ['16B75870A3767788A0F1BC83AACD1DDC']);
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(MyApp());
    Wakelock.enable();
  });
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

