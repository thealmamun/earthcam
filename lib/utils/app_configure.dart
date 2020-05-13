import 'package:earth_cam/pages/search_cams.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import 'constants.dart';

class AppConfig {
  static const appName = 'EarthCam';

  static const appLogo = 'assets/images/appLogo.png';


  static const mapBoxUrlLink =
      'https://api.mapbox.com/styles/v1/mrn92/ck9yhnklj2e4x1isa1d4nhfkt/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoibXJuOTIiLCJhIjoiY2s5ZWsxaG9sMDJoYjNoczByODVoZ2E4MSJ9.D7V4rRBacLMvv7t3oYQEeQ';

  static const mapBoxAccessToken =
      'pk.eyJ1IjoibXJuOTIiLCJhIjoiY2s5ZWsxaG9sMDJoYjNoczByODVoZ2E4MSJ9.D7V4rRBacLMvv7t3oYQEeQ';

  static const adUnitID = "ca-app-pub-3940256099942544/8135179316";

  static TextStyle appNameStyle = GoogleFonts.righteous(
    fontSize: 30,
    color: AppColor.kThemeColor,
  );

  static const appLeadingIcon = Icon(
    Icons.camera,
    color: AppColor.kThemeColor,
    size: 30,
  );

  static appBarSearchButton(BuildContext context){
    return InkWell(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Icon(
          FontAwesomeIcons.searchLocation,
          size: 30,
        ),
      ),
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) {
              return SearchCams();
            },
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
          ),
        );
      },
    );
  }


}
