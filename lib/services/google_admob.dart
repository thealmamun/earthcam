// 📦 Package imports:
import 'package:earth_cam/utils/app_configure.dart';
import 'package:firebase_admob/firebase_admob.dart';

//const String testDevice = '43C11668467B0AE9AE0E76DD89D3FC79';
//
//const MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
//    testDevices: testDevice != null ? <String>[testDevice] : null,
//    nonPersonalizedAds: true,
//    keywords: <String>['cams','live','earth']);

class GoogleAdMob {
//  static BannerAd _bannerAd;

  static void initialize() {
    FirebaseAdMob.instance.initialize(appId: AppConfig.addId);
  }

//  static BannerAd _createBannerAd() {
//    return BannerAd(
//      adUnitId: AppConfig.bannerAdId,
//      size: AdSize.smartBanner,
//      listener: (MobileAdEvent event) {
//        print("BannerAd event is $event");
//      },
//    );
//  }
//
//  static void showBannerAd() {
//    if (_bannerAd == null) _bannerAd = _createBannerAd();
//    _bannerAd
//      ..load()
//      ..show(anchorOffset: 0.0, anchorType: AnchorType.bottom);
//  }

  static void showInterstitialAds() {
    var interstitialAd = InterstitialAd(
      adUnitId: AppConfig.interstitialAdId,
      listener: (MobileAdEvent event) {
        print("InterstitialAd event is $event");
      },
    );
    interstitialAd
      ..load()
      ..show(anchorOffset: 0.0, anchorType: AnchorType.bottom);
  }

//  static void hideBannerAd()  async{
//    await _bannerAd.dispose();
//    _bannerAd = null;
//  }

//  static BannerAd _createAnotherBannerAd() {
//    return BannerAd(
//      adUnitId: AppConfig.bannerAdId,
////      adUnitId: BannerAd.testAdUnitId,
//      size: AdSize.fullBanner,
//      listener: (MobileAdEvent event) {
//        print("BannerAd event is $event");
//      },
//    );
//  }
//
//  static void showAnotherBannerAd() {
//    if (_AnotherBannerAd == null) _AnotherBannerAd = _createAnotherBannerAd();
//    _AnotherBannerAd
//      ..load()
//      ..show(anchorOffset: 0.0, anchorType: AnchorType.bottom);
//  }
//
//  static void hideAnotherBannerAd()  async{
//    await _AnotherBannerAd.dispose();
//    _AnotherBannerAd = null;
//  }
//
//  static void hideInterstitialAds() async {
//    await _interstitialAd.dispose();
//    _interstitialAd = null;
//  }
}
