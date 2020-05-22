// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

// 🌎 Project imports:
import 'package:earth_cam/pages/search_cams.dart';
import 'constants.dart';

class AppConfig {
  static const appName = 'EarthCam';

  static const appLogo = 'assets/images/appLogo.png';


  static const mapBoxUrlLink =
      'https://api.mapbox.com/styles/v1/earthcamera/cka9c9phq0eun1imibhlnv0ur/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoiZWFydGhjYW1lcmEiLCJhIjoiY2thOTkwaWRlMDh6ejJybjUwdWNvZTM2OCJ9.4tYB7cnFLfA-lP2sYYw6-A';

  static const mapBoxAccessToken =
      'pk.eyJ1IjoiZWFydGhjYW1lcmEiLCJhIjoiY2thOTkwaWRlMDh6ejJybjUwdWNvZTM2OCJ9.4tYB7cnFLfA-lP2sYYw6-A';

  static const addId = "ca-app-pub-3560277835764465~1612694609";

  static const nativeAddId = "ca-app-pub-3560277835764465/5221315861";

  static const interstitialAdId = "ca-app-pub-3560277835764465/3325780261";

  static const bannerAdId = "ca-app-pub-3560277835764465/6315384614";

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
