// 📦 Package imports:
import 'package:firebase_admob/firebase_admob.dart';

// 🌎 Project imports:
import 'package:earth_cam/utils/app_configure.dart';

//const String testDevice = '43C11668467B0AE9AE0E76DD89D3FC79';

//const MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
//    testDevices: testDevice != null ? <String>[testDevice] : null,
//    nonPersonalizedAds: true,
//    keywords: <String>['result', 'exam', 'scholarship', 'student visa','addmission','student jobs','jobs']);


class GoogleAdMob{

  BannerAd _bannerAd;
  InterstitialAd _interstitialAd;

  @override
  void dispose() {
    _bannerAd.dispose();
    _interstitialAd.dispose();
//    super.dispose();
  }

  BannerAd createBannerAd() {
    return BannerAd(
        adUnitId: AppConfig.bannerAdId,
        size: AdSize.banner,
        listener: (MobileAdEvent event) {
          print('BannerAd $event');
        });
  }

  InterstitialAd createInterstitialAd() {
    return InterstitialAd(
        adUnitId: AppConfig.interstitialAdId,
        listener: (MobileAdEvent event) {
          print('InterstitialAd $event');
        });
  }

  showInterstitialAds(){
    _interstitialAd = createInterstitialAd()
      ..load()
      ..show();
  }

  showBannerAds(){
    _bannerAd = createBannerAd()
      ..load()
      ..show(anchorOffset: 50);
  }

}
