import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:earth_cam/model/cams.dart';
import 'package:earth_cam/pages/search_cams.dart';
import 'package:earth_cam/services/database.dart';
import 'package:earth_cam/utils/constants.dart';
import 'package:earth_cam/widgets/map_pin_pill.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapView extends StatefulWidget {
  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  GoogleMapController _controller;
//  Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _markers = {};
//  PageController _pageController;
  int prevPage;
  bool isClicked = false;
  List<Cams> cams = List<Cams>();
  Stream dataList;
  BitmapDescriptor markerIcon;
  double pinPillPosition = -200;
  Cams currentlySelectedPin = Cams(
      address: '',
      camTitle: '',
      geoPoint: GeoPoint(0.0,0.0),
      imageUrl: '',
      streamUrl: '',
      category: '',
  );
  Cams camInfo;
  String _mapStyle;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setSourceAndDestinationIcons();
//    _pageController = PageController(initialPage: 1, viewportFraction: 0.8,keepPage: false)
//      ..addListener(_onScroll);
    rootBundle.loadString('assets/map_style.txt').then((string) {
      _mapStyle = string;
    });
  }

//  void screenMarker() async{
//    await mapData.forEach((element) {
//      for (var i = 0; i < element.length; i++) {
//        final markerId = MarkerId(element[i].toString());
//        print(markerId);
//        allMarkers.add(
//          Marker(
//            onTap: markerClicked(markerId),
//            icon: markerIcon,
//            markerId: markerId,
//            draggable: false,
//            infoWindow: InfoWindow(
//                title: element[i].camTitle, snippet: element[i].address),
//            position: LatLng(
//                element[i].geoPoint.latitude, element[i].geoPoint.longitude),
//          ),
//        );
//      }
//    });
//  }
  void setSourceAndDestinationIcons() async {
    markerIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5),
        'assets/images/marker.png');
  }
  markerClicked(MarkerId markerId){
    print('here');
  }

//  void _onScroll() {
//    if (_pageController.page.toInt() != prevPage) {
//      prevPage = _pageController.page.toInt();
////      moveCamera();
//    }
//  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFF1B2D45),
        appBar: AppBar(
          elevation: 10,
          iconTheme: IconThemeData(
              color: AppColor.kThemeColor
          ),
          centerTitle: true,
          title: Text('Camera World',style: GoogleFonts.righteous(fontSize: 30,color: AppColor.kThemeColor),),
          backgroundColor: AppColor.kAppBarBackgroundColor,
          actions: [
            GestureDetector(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  FontAwesomeIcons.searchLocation,
                  size: 25,
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) {
                      return SearchCams();
                    },
                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                      return FadeTransition(
                        opacity: animation,
                        child: child,
                      );
                    },
                  ),
                );
//              Navigator.push(context,
//                  MaterialPageRoute(builder: (context) => SearchCams()));
              },
            ),
            GestureDetector(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.do_not_disturb_off,
                    color: AppColor.kThemeColor,
                    size: 25,
                  ),
                ),
                onTap: null),
          ],
        ),
        body: Stack(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height - 50.0,
              width: MediaQuery.of(context).size.width,
              child: GoogleMap(
                zoomGesturesEnabled: true,
                compassEnabled: true,
                mapToolbarEnabled: true,
                zoomControlsEnabled: false,
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                initialCameraPosition: CameraPosition(
                    target: LatLng(40.7128, -74.0060), zoom: 12.0),
                markers: _markers,
                onMapCreated: (GoogleMapController controller) {
                  _controller = controller;
                  _controller.setMapStyle(_mapStyle);
                  setState(() {
                    setMapPins();
                  });
                },
                padding: EdgeInsets.only(top: 40.0,),
              ),
            ),
            MapPinPillComponent(
                pinPillPosition: pinPillPosition,
                currentlySelectedPin: currentlySelectedPin
            ),
            isClicked
                ? Container(
                    padding: EdgeInsets.only(top: 30),
                    alignment: Alignment.topRight,
                    child: RaisedButton.icon(
                      elevation: 20,
                      shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            topLeft: Radius.circular(20)),
                      ),
                      onPressed: () {
                        print('YT cam Clicked');
                        setState(() {
                          isClicked = false;
                          _markers.clear();
                          ytMap.forEach((element) {
                            for (var i = 0; i < element.length; i++) {
                              _markers.add(
                                Marker(
                                  onTap: () {
                                    setState(() {
                                      currentlySelectedPin = Cams(
                                        address: element[i].address,
                                        camTitle: element[i].camTitle,
                                        geoPoint: GeoPoint(element[i].geoPoint.latitude, element[i].geoPoint.longitude),
                                        imageUrl: element[i].imageUrl,
                                        streamUrl: element[i].streamUrl,
                                        category: element[i].category,
                                      );
                                      pinPillPosition = 0;
                                    });
                                  },
                                  markerId: MarkerId(element[i].geoPoint.latitude.toString()),
                                  position: LatLng(
                                      element[i].geoPoint.latitude, element[i].geoPoint.longitude),
                                ),
                              );
                            }
                            setState(() {
                              pinPillPosition = -200;
                            });
                          });
                        });
                      },
                      icon: Icon(
                        Icons.play_arrow,
                        color: Colors.white,
                      ),
                      label: Text(
                        'YT Cam',
                        style: TextStyle(color: Colors.white),
                      ),
                      color: Colors.redAccent,
                    ),
                  )
                : Container(
                    padding: EdgeInsets.only(top: 30),
                    alignment: Alignment.topRight,
                    child: RaisedButton.icon(
                      elevation: 20,
                      shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            topLeft: Radius.circular(20)),
                      ),
                      onPressed: () {
                        print('IP cam Clicked');
                        setState(() {
                          isClicked = true;
                          _markers.clear();
                        });
                        print(_markers);
                        ipCam.forEach((element) {
                          for (var i = 0; i < element.length; i++) {
                            _markers.add(
                              Marker(
                                onTap: () {
                                  setState(() {
                                    currentlySelectedPin = Cams(
                                      address: element[i].address,
                                      camTitle: element[i].camTitle,
                                      geoPoint: GeoPoint(element[i].geoPoint.latitude, element[i].geoPoint.longitude),
                                      imageUrl: element[i].imageUrl,
                                      streamUrl: element[i].streamUrl,
                                      category: element[i].category,
                                    );
                                    pinPillPosition = 0;
                                  });
                                },
                                markerId: MarkerId(element[i].geoPoint.latitude.toString()),
                                position: LatLng(
                                    element[i].geoPoint.latitude, element[i].geoPoint.longitude),
                              ),
                            );
                            setState(() {
                              pinPillPosition = -200;
                            });
                          }
                        });
//                        Navigator.push(
//                            context,
//                            MaterialPageRoute(
//                                builder: (context) => ServerVideoPlayer()));
                      },
                      icon: Icon(
                        Icons.linked_camera,
                        color: Colors.white,
                      ),
                      label: Text(
                        'IP Cam',
                        style: TextStyle(color: Colors.white),
                      ),
                      color: Colors.indigo,
                    ),
                  )
          ],
        ),
        drawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('Drawer Header'),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              title: Text('Item 1'),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
            ListTile(
              title: Text('Item 2'),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
          ],
        ),
      ),
    );
  }

//  void mapCreated(controller) {
//    setState(() {
//      _controller = controller;
//      setMapPins();
//    });
//  }

  setMapPins(){
    mapData.forEach((element) {
      for (var i = 0; i < element.length; i++) {
        _markers.add(
          Marker(
            onTap: () {
              setState(() {
                currentlySelectedPin = Cams(
                  address: element[i].address,
                  camTitle: element[i].camTitle,
                  geoPoint: GeoPoint(element[i].geoPoint.latitude, element[i].geoPoint.longitude),
                  imageUrl: element[i].imageUrl,
                  streamUrl: element[i].streamUrl,
                  category: element[i].category,
                );
                pinPillPosition = 0;
              });
            },
            markerId: MarkerId(element[i].geoPoint.latitude.toString()),
//            markerId: MarkerId(element[i].geoPoint.latitude.toString()),
//            draggable: false,
//            infoWindow: InfoWindow(
//                title: element[i].camTitle, snippet: element[i].address),
            position: LatLng(
                element[i].geoPoint.latitude, element[i].geoPoint.longitude),
          ),
        );
      }
    });
  }

  moveCamera(GeoPoint geoPoint) {
    _controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(geoPoint.latitude, geoPoint.longitude),
        zoom: 14.0,
        bearing: 45.0,
        tilt: 45.0)));
  }
}
