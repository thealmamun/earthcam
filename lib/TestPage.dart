//import 'package:flutter/material.dart';
//
//class Categories extends StatefulWidget {
//  @override
//  _CategoriesState createState() => _CategoriesState();
//}
//
//class _CategoriesState extends State<Categories> {
//  Widget _cardList() {
//    return SingleChildScrollView(
//      scrollDirection: Axis.vertical,
//      child: Container(
//        child: Column(
//          mainAxisAlignment: MainAxisAlignment.start,
//          children: <Widget>[
//            _card(
//                primary: LightColor.seeBlue,
//                backWidget: _decorationContainerD(
//                    LightColor.darkseeBlue, -100, -65,
//                    secondary: LightColor.lightseeBlue,
//                    secondaryAccent: LightColor.seeBlue),
//                title: "One",
//                imgPath:
//                "https://www.reiss.com/media/product/946/218/silk-paisley-printed-pocket-square-mens-morocco-in-pink-red-20.jpg?format=jpeg&auto=webp&quality=85&width=1200&height=1200&fit=bounds"),
//            _card(
//                primary: LightColor.darkBlue,
//                backWidget: _decorationContainerE(
//                  LightColor.lightpurple,
//                  90,
//                  -40,
//                  secondary: LightColor.lightseeBlue,
//                ),
//                title: "Two",
//                imgPath:
//                "https://i.dailymail.co.uk/i/pix/2016/08/05/19/36E9139400000578-3725856-image-a-58_1470422921868.jpg"),
//            _card(
//                primary: LightColor.lightBlue,
//                backWidget: _decorationContainerF(
//                    LightColor.lightOrange, LightColor.orange, 50, -30),
//                title: "Three",
//                imgPath:
//                "https://www.reiss.com/media/product/945/066/03-2.jpg?format=jpeg&auto=webp&quality=85&width=632&height=725&fit=bounds"),
//            _card(
//                primary: LightColor.extraDarkPurple,
//                backWidget: _decorationContainerB(
//                  Colors.white,
//                  -50,
//                  30,
//                ),
//                title: "Four",
//                imgPath:
//                "https://img.alicdn.com/imgextra/i4/52031722/O1CN0165X68s1OaiaYCEX6U_!!52031722.jpg"),
//            _card(
//                primary: LightColor.darkseeBlue,
//                backWidget: _decorationContainerA(
//                    LightColor.lightOrange, 50, -30),
//                title: "Five",
//                imgPath:
//                "https://www.reiss.com/media/product/945/066/03-2.jpg?format=jpeg&auto=webp&quality=85&width=632&height=725&fit=bounds"),
//
//          ],
//        ),
//      ),
//    );
//  }
//
//  Widget _card({
//    Color primary = Colors.redAccent,
//    String imgPath,
//    String title = '',
//    Widget backWidget,
//  }) {
//    return Container(
//        height: 150,
//        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
//        decoration: BoxDecoration(
//            color: primary.withAlpha(200),
//            borderRadius: BorderRadius.all(Radius.circular(20)),
//            boxShadow: <BoxShadow>[
//              BoxShadow(
//                  offset: Offset(0, 5),
//                  blurRadius: 10,
//                  color: Colors.purpleAccent.withAlpha(20))
//            ]),
//        child: ClipRRect(
//          borderRadius: BorderRadius.all(Radius.circular(20)),
//          child: Container(
//            child: Stack(
//              children: <Widget>[
//                backWidget,
//                Positioned(
//                  top: 20,
//                  left: 10,
//                  child: CircleAvatar(
//                    radius: 50.0,
//                    backgroundColor: Colors.grey.shade300,
//                    backgroundImage: NetworkImage(imgPath),
//                  ),
//                ),
//                Positioned(
//                  top: 30,
//                  left: 150,
//                  child: _cardInfo(
//                    title,
//                    Colors.black,
//                  ),
//                ),
//              ],
//            ),
//          ),
//        ));
//  }
//
//  Widget _cardInfo(
//      String title,
//      Color textColor,
//      ) {
//    return Align(
//      child: Column(
//        crossAxisAlignment: CrossAxisAlignment.start,
//        children: <Widget>[
//          Container(
//            padding: EdgeInsets.only(right: 10),
//            width: MediaQuery.of(context).size.width * .50,
//            child: Text(
//              title,
//              style: TextStyle(
//                  fontSize: 20, fontWeight: FontWeight.bold, color: textColor),
//            ),
//          ),
//        ],
//      ),
//    );
//  }
//
//  Widget _circularContainer(double height, Color color,
//      {Color borderColor = Colors.transparent, double borderWidth = 2}) {
//    return Container(
//      height: height,
//      width: height,
//      decoration: BoxDecoration(
//        shape: BoxShape.circle,
//        color: color,
//        border: Border.all(color: borderColor, width: borderWidth),
//      ),
//    );
//  }
//
//  Positioned _smallContainer(Color primary, double top, double left,
//      {double radius = 10}) {
//    return Positioned(
//        top: top,
//        left: left,
//        child: CircleAvatar(
//          radius: radius,
//          backgroundColor: primary.withAlpha(255),
//        ));
//  }
//
//  Widget _decorationContainerA(Color primary, double top, double left) {
//    return Stack(
//      children: <Widget>[
//        Positioned(
//          top: top,
//          left: left,
//          child: CircleAvatar(
//            radius: 100,
//            backgroundColor: primary.withAlpha(255),
//          ),
//        ),
//        _smallContainer(primary, 20, 40),
//        Positioned(
//          top: 20,
//          right: -30,
//          child: _circularContainer(80, Colors.transparent,
//              borderColor: Colors.white),
//        )
//      ],
//    );
//  }
//
//  Widget _decorationContainerB(Color primary, double top, double left) {
//    return Stack(
//      children: <Widget>[
//        Positioned(
//          top: -65,
//          right: -65,
//          child: CircleAvatar(
//            radius: 70,
//            backgroundColor: Colors.blue.shade100,
//            child: CircleAvatar(radius: 30, backgroundColor: primary),
//          ),
//        ),
//        Positioned(
//            top: 35,
//            right: -40,
//            child: ClipRect(
//                clipper: QuadClipper(),
//                child: CircleAvatar(
//                    backgroundColor: Color(0xffb9e6fc), radius: 40)))
//      ],
//    );
//  }
//
//
//  Widget _decorationContainerD(Color primary, double top, double left,
//      {Color secondary, Color secondaryAccent}) {
//    return Stack(
//      children: <Widget>[
//        Positioned(
//          top: top,
//          left: left,
//          child: CircleAvatar(
//            radius: 100,
//            backgroundColor: secondary,
//          ),
//        ),
//        _smallContainer(Color(0xfffbbd5c), 18, 35, radius: 12),
//        Positioned(
//          top: 130,
//          left: -50,
//          child: CircleAvatar(
//            radius: 80,
//            backgroundColor: primary,
//            child: CircleAvatar(radius: 50, backgroundColor: secondaryAccent),
//          ),
//        ),
//        Positioned(
//          top: -30,
//          right: -40,
//          child: _circularContainer(80, Colors.transparent,
//              borderColor: Colors.white),
//        )
//      ],
//    );
//  }
//
//  Widget _decorationContainerE(Color primary, double top, double left,
//      {Color secondary}) {
//    return Stack(
//      children: <Widget>[
//        Positioned(
//          top: -105,
//          left: -35,
//          child: CircleAvatar(
//            radius: 70,
//            backgroundColor: primary.withAlpha(100),
//          ),
//        ),
//        Positioned(
//            bottom: -40,
//            right: -15,
//            child: ClipRect(
//                clipper: QuadClipper(),
//                child: CircleAvatar(backgroundColor: primary, radius: 40))),
//        Positioned(
//            bottom:-50,
//            right: -50,
//            child: ClipRect(
//                clipper: QuadClipper(),
//                child: CircleAvatar(backgroundColor: secondary, radius: 50))),
//        _smallContainer(Color(0xfffbbd5c), 15, 90, radius: 5)
//      ],
//    );
//  }
//
//  Widget _decorationContainerF(
//      Color primary, Color secondary, double top, double left) {
//    return Stack(
//      children: <Widget>[
//        Positioned(
//            bottom: -50,
//            right: -20,
//            child: RotatedBox(
//              quarterTurns: 1,
//              child: ClipRect(
//                  clipper: QuadClipper(),
//                  child: CircleAvatar(
//                      backgroundColor: primary.withAlpha(100), radius: 50)),
//            )),
//        Positioned(
//            bottom: -50,
//            right: -8,
//            child: ClipRect(
//                clipper: QuadClipper(),
//                child: CircleAvatar(
//                    backgroundColor: secondary.withAlpha(100), radius: 40))),
//        _smallContainer(Color(0xfffbbd5c), 15, 90, radius: 5)
//      ],
//    );
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(
//        centerTitle: true,
//        title: Text('Categories'),
//        actions: [
//          IconButton(
//              icon: Icon(
//                Icons.search,
//                color: Colors.white,
//                size: 30,
//              ),
//              onPressed: null),
//          IconButton(
//              icon: Icon(
//                Icons.do_not_disturb_off,
//                color: Colors.white,
//                size: 25,
//              ),
//              onPressed: null),
//        ],
//      ),
//      body: SingleChildScrollView(
//        child: Container(
//          child: Column(
//            children: <Widget>[
//              _cardList(),
//            ],
//          ),
//        ),
//      ),
//    );
//  }
//}
//
//class QuadClipper extends CustomClipper<Rect> {
//  @override
//  Rect getClip(Size size) {
//    Rect rect = Rect.fromLTRB(0.0, 0.0, size.width / 2, size.height / 2);
//    return rect;
//  }
//
//  @override
//  bool shouldReclip(CustomClipper<Rect> oldClipper) {
//    return true;
//  }
//}
//
//class LightColor {
//  static const Color background = Color(0XFFFFFFFF);
//
//  static const Color titleTextColor = const Color(0xff5a5d85);
//  static const Color subTitleTextColor = const Color(0xff797878);
//
//  static const Color bottonTitleTextColor = const Color(0xffd4d4ea);
//
//  static const Color grey = Color(0xff9D99A7);
//  static const Color darkgrey = Color(0xff625f6a);
//
//  static const Color yellow = Color(0xfffbbd5c);
//
//  static const Color orange = Color(0xfff96d5b);
//  static const Color darkOrange = Color(0xfff46352);
//  static const Color lightOrange = Color(0xfffa8e5c);
//  static const Color lightOrange2 = Color(0xfff97d6d);
//
//  static const Color purple = Color(0xff7a81dd);
//  static const Color lightpurple = Color(0xff898edf);
//  static const Color darkpurple = Color(0xff7178d3);
//  static const Color extraDarkPurple = Color(0xff494c79);
//
//  static const Color seeBlue = Color(0xff73d4dd);
//  static const Color darkseeBlue = Color(0xff63c4cf);
//  static const Color lightseeBlue = Color(0xffb9e6fc);
//
//  static const Color brighter = Color(0xff3754aa);
//  static const Color Darker = Color(0xffffffff);
//  static const Color black = Color(0xff040405);
//  static const Color lightblack = Color(0xff3E404D);
//  static const Color lightGrey = Color(0xffDFE7DD);
//  static const Color darkBlue = Color(0xff13165A);
//  static const Color lightBlue = Color(0xff203387);
//}
