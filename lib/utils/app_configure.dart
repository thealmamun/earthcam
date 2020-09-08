// 🐦 Flutter imports:
import 'package:earth_cam/pages/search_cams.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import 'constants.dart';

class AppConfig {
  static const appName = 'EarthCam';

  static const appLogo = 'assets/images/logo.png';

  static const mapBoxUrlLink =
      'https://api.mapbox.com/styles/v1/earthcamera/cka9c9phq0eun1imibhlnv0ur/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoiZWFydGhjYW1lcmEiLCJhIjoiY2thOTkwaWRlMDh6ejJybjUwdWNvZTM2OCJ9.4tYB7cnFLfA-lP2sYYw6-A';

  static const mapBoxAccessToken =
      'pk.eyJ1IjoiZWFydGhjYW1lcmEiLCJhIjoiY2thOTkwaWRlMDh6ejJybjUwdWNvZTM2OCJ9.4tYB7cnFLfA-lP2sYYw6-A';

  static const addId = "ca-app-pub-8059669329564617~8195985061";

  static const nativeAddId = "ca-app-pub-8059669329564617/1137899926";

  static const interstitialAdId = "ca-app-pub-8059669329564617/1947391046";

  static const bannerAdId = "ca-app-pub-8059669329564617/5077144930";

  static const facebookNativeAdId = "PASTE_FACEBOOK_NATIVE_AD_CODE_HERE";

  static TextStyle appNameStyle = GoogleFonts.righteous(
    fontSize: 30,
    color: AppColor.kThemeColor,
  );

  static const appLeadingIcon = Icon(
    Icons.camera,
    color: AppColor.kThemeColor,
    size: 30,
  );

  static appBarSearchButton(BuildContext context) {
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
