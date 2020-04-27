import 'package:earth_cam/model/cams.dart';
import 'package:earth_cam/pages/launch_video.dart';
import 'package:earth_cam/pages/yt_video_player.dart';
import 'package:flutter/material.dart';

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
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(20)),
              boxShadow: <BoxShadow>[
                BoxShadow(
                    blurRadius: 20,
                    offset: Offset.zero,
                    color: Colors.grey.withOpacity(0.5))
              ]),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 70,
                height: 70,
                margin: EdgeInsets.only(left: 10),
                child: ClipOval(
                    child: Image.network(widget.currentlySelectedPin.imageUrl,
                        fit: BoxFit.cover)),
              ),
              Expanded(
                child: Container(
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        widget.pinPillPosition = -200;
                      });
                    },
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
                                  widget.currentlySelectedPin.address,
                                  textAlign: TextAlign.start,
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
                                child: Icon(Icons.cancel),
                              ),
                            ),
                          ],
                        ),
                        FlatButton.icon(
                            onPressed: () {
                              print(widget.currentlySelectedPin.streamUrl);
                              if (widget.currentlySelectedPin.category ==
                                  'Youtube') {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => YtVideoPlayerPage(
                                              url: widget.currentlySelectedPin
                                                  .streamUrl,
                                            )));
                              } else {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LaunchVideo(
                                              url: widget.currentlySelectedPin
                                                  .streamUrl,
                                            )));
                              }
                            },
                            icon: Icon(Icons.play_arrow),
                            label: Text('Play'))
                      ],
                    ),
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
