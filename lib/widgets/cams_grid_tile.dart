// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neumorphic/neumorphic.dart';

// 🌎 Project imports:
import 'package:earth_cam/utils/constants.dart';

class CamsGridTile extends StatefulWidget {
  CamsGridTile(
      {this.context,
      this.snapshot,
      this.imageUrl,
      this.onPressed,
      this.camTitle,
      this.onPressedFavourite,this.onFavPress,this.flareWidget});

  final BuildContext context;
  final DocumentSnapshot snapshot;
  final String imageUrl;
  final Function onPressed;
  final Function onPressedFavourite;
  final String camTitle;
  final bool onFavPress;
  final Widget flareWidget;

  @override
  _CamsGridTileState createState() => _CamsGridTileState();
}

class _CamsGridTileState extends State<CamsGridTile> {
//  bool isPressed = false;
  @override
  Widget build(BuildContext context) {
    return GridTile(
      footer: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 60,
              decoration: BoxDecoration(
                  color: Color(0xff3d3e40),
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(18),
                      bottomLeft: Radius.circular(18))),
//              color: Color(0xff3d3e40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        widget.camTitle,
                        style: GoogleFonts.roboto(
                            fontSize: 15,
                            color: AppColor.kTextColor,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.favorite,
//                        color: AppColor.kThemeColor,
                      color: Colors.pinkAccent,
                    ),
                    onPressed: widget.onPressedFavourite,
                  ),
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
              Positioned.fill(
                child: Container(
                  child: FancyShimmerImage(
                    boxFit: BoxFit.fill,
                    imageUrl: widget.imageUrl,
                    errorWidget: Icon(Icons.error),
                  ),
                ),
              ),
              Positioned.fill(
                bottom: 40,
                child: Container(
                  color: Colors.black.withOpacity(0.4),
                  child: IconButton(
                    color: Colors.grey,
                    icon: Icon(
                      Icons.play_circle_filled,
                      size: 35,
                      color: AppColor.kThemeColor,
                    ),
                    onPressed: widget.onPressed,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
