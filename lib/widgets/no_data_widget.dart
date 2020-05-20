// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:google_fonts/google_fonts.dart';

class NoDataWidget extends StatelessWidget {
  NoDataWidget({this.text});
  final String text;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        height: 200,
        width: double.maxFinite,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Container(
                height: 100,
                  child: Image.asset('assets/images/novideo.png',scale: 1.0,),),
            ),
            SizedBox(height: 10,),
            Expanded(
              child: Center(
                child: Text(
                  text,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.roboto(fontSize: 30, color: Colors.white70),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
