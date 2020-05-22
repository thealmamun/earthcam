// 🎯 Dart imports:
import 'dart:ui';

// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neumorphic/neumorphic.dart';

// 🌎 Project imports:
import 'package:earth_cam/pages/country_cams.dart';
import 'package:earth_cam/services/google_admob.dart';
import 'package:earth_cam/utils/app_configure.dart';
import 'package:earth_cam/utils/constants.dart';

class CountryList extends StatefulWidget {
  @override
  _CountryListState createState() => _CountryListState();
}

class _CountryListState extends State<CountryList> {
  Stream countryList;

  Widget _countryList(DocumentSnapshot doc) {
    return InkWell(
      onTap: (){
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) {
              return CountryCams(
                selectedCountry: doc.data['countryTitle'],
                selectedCountryTitle: doc.data['countryTitle'],
                selectedCountryFlag: doc.data['countryFlag'],
              );
            },
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
          ),
        );
      },
      child: GridTile(
        footer: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 50,
                decoration: BoxDecoration(
                    color: AppColor.kBackgroundColor,
                    borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(18),
                        bottomLeft: Radius.circular(18))),
//              color: Color(0xff3d3e40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Text(
                          doc.data['countryTitle'],
                          style: GoogleFonts.roboto(
                              fontSize: 15,
                              color: AppColor.kTextColor,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 1.0),
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: SizedBox(
                                child: Text(
                                  doc.data['videosCount'].toString(),
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                          Icon(
                            Icons.linked_camera,
                            size: 15,
                            color: AppColor.kThemeColor,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: NeuCard(
            curveType: CurveType.concave,
            bevel: 5,
            decoration: NeumorphicDecoration(
                color: Color(0xff212121),
                borderRadius: BorderRadius.circular(20)),
            child: Stack(
              children: <Widget>[
                Positioned(
                  bottom: 30,
                  right: 1,
                  child: Container(
                    child: Center(
                      child: Text(
                        doc.data['countryFlag'],
                        style: TextStyle(fontSize: 150),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    GoogleAdMob.showInterstitialAds();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    print('dispose');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 10,
        iconTheme: IconThemeData(color: AppColor.kThemeColor),
        centerTitle: true,
        title: Text(
          AppConfig.appName,
          style: AppConfig.appNameStyle,
        ),
        backgroundColor: AppColor.kAppBarBackgroundColor,
        actions: [
          AppConfig.appBarSearchButton(context),
        ],
        leading: AppConfig.appLeadingIcon,
      ),
      body: Center(
        child: Container(
          color: AppColor.kBackgroundColor,
          child: StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance.collection('countries').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Center(
                    child: Container(
                      child: Column(
                        children: [
                          Expanded(
                            child: GridView.count(
                              crossAxisCount: 2,
                              childAspectRatio: 1.0,
                              mainAxisSpacing: 2.0,
                              crossAxisSpacing: 2.0,
                              children: snapshot.data.documents
                                  .map(
                                    (doc) => _countryList(doc),
                                  )
                                  .toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                } else
                  return Center(child: CircularProgressIndicator());
              }),
        ),
      ),
    );
  }
}
