// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 🌎 Project imports:
import 'package:earth_cam/model/cams.dart';
import 'package:earth_cam/pages/general_video_player.dart';
import 'package:earth_cam/pages/youtube_video_player.dart';
import 'package:earth_cam/utils/constants.dart';

// ignore: must_be_immutable
class MapPinPillComponent extends StatefulWidget {
  double pinPillPosition;
  Cams currentlySelectedPin;

  MapPinPillComponent({this.pinPillPosition, this.currentlySelectedPin});

  @override
  State<StatefulWidget> createState() => MapPinPillComponentState();
}

class MapPinPillComponentState extends State<MapPinPillComponent> {
  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      bottom: widget.pinPillPosition,
      right: 0,
      left: 0,
      duration: Duration(milliseconds: 200),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          margin: EdgeInsets.all(20),
          height: 100,
          decoration: BoxDecoration(
              color: AppColor.kAppBarBackgroundColor,
              borderRadius: BorderRadius.all(Radius.circular(20)),
              boxShadow: <BoxShadow>[
                BoxShadow(
                    blurRadius: 30,
                    spreadRadius: 1,
                    offset: Offset(0,5),
                    color: Colors.grey.withOpacity(0.5))
              ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 70,
                height: 70,
                margin: EdgeInsets.only(left: 10),
                child: Image.network(widget.currentlySelectedPin.imageUrl,
                    fit: BoxFit.cover),
              ),
              Expanded(
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                widget.currentlySelectedPin.camTitle,
                                textAlign: TextAlign.start,
                                style: TextStyle(color: Colors.white70),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  widget.pinPillPosition = -200;
                                });
                              },
                              child: Icon(Icons.cancel,color: Colors.white70,),
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: FlatButton.icon(
                            onPressed: () {
                              print(widget.currentlySelectedPin.streamUrl);
                              if (widget.currentlySelectedPin.camType ==
                                  'Youtube') {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => YtVideoPlayerPage(
                                              url: widget.currentlySelectedPin.streamUrl,
                                              imageUrl: widget.currentlySelectedPin.imageUrl,
                                            )));
                              } else {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ServerVideoPlayer(
                                              url: widget.currentlySelectedPin.streamUrl,
                                              imageUrl: widget.currentlySelectedPin.imageUrl,
                                            )));
                              }
                            },
                            icon: Icon(Icons.play_arrow,color: Colors.white70,),
                            label: Text('Play',style: TextStyle(color: Colors.white70,),)),
                      )
                    ],
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
