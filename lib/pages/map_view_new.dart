import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:earth_cam/model/cams.dart';
import 'package:earth_cam/pages/search_cams.dart';
import 'package:earth_cam/pages/server_video_player.dart';
import 'package:earth_cam/pages/yt_video_player.dart';
import 'package:earth_cam/services/database.dart';
import 'package:earth_cam/utils/constants.dart';
import 'package:earth_cam/widgets/map_pin_pill.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong/latlong.dart';

import 'package:location/location.dart';
import 'package:shimmer/shimmer.dart';

class MapViewNew extends StatefulWidget {
  @override
  _MapViewNewState createState() => _MapViewNewState();
}

class _MapViewNewState extends State<MapViewNew> {
  LatLng _center = LatLng(23.75553435912065, 90.4116352647543);
  MapController _mapController = MapController();
  double pinPillPosition = -200;
  Cams currentlySelectedPin = Cams(
    address: '',
    camTitle: '',
    geoPoint: GeoPoint(0.0, 0.0),
    imageUrl: '',
    streamUrl: '',
    country: '',
  );
  List<Marker> markers = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
//    _buildMarkersOnMap();
    Future.delayed(const Duration(milliseconds: 500), () {
      getCurrentLocation();
    });
  }

  getCurrentLocation() async {
    Location location = new Location();
    LocationData _locationData;

    _locationData = await location.getLocation();

    setState(() {
      //_center = LatLng(_locationData.latitude, _locationData.longitude);
      _mapController.move(
          LatLng(_locationData.latitude, _locationData.longitude), 20.0);

      print(_locationData);

      currentlySelectedPin = Cams(
        address: '',
        camTitle: '',
        geoPoint: GeoPoint(0.0, 0.0),
        imageUrl: '',
        streamUrl: '',
        country: '',
      );
      pinPillPosition = -200;
    });
  }

  _buildMarkersOnMap() {
//    Future.delayed(const Duration(milliseconds: 500), () {
//
//    });
    mapData.forEach((element) {
      for (var i = 0; i < element.length; i++) {
        var marker = Marker(
          height: 50,
          width: 50,
          point: LatLng(
              element[i].geoPoint.latitude, element[i].geoPoint.longitude),
          builder: (context) => _buildCustomMarker(
            imageUrl: element[i].imageUrl,
            camTitle: element[i].camTitle,
            address: element[i].address,
            streamUrl: element[i].streamUrl,
            country: element[i].country,
          ),
        );
        markers.add(marker);
        print(marker);
      }
    });
    return markers;
  }

  Container _buildCustomMarker(
      {String imageUrl, camTitle, address, streamUrl, country}) {
    return Container(
      child: marker(
          imageUrl: imageUrl,
          camTitle: camTitle,
          address: address,
          streamUrl: streamUrl,
          country: country),
    );
  }

  Align popup({String imageUrl, camTitle, address, streamUrl, category}) {
    return Align(
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
                offset: Offset(0, 5),
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
              child:
                  ClipOval(child: Image.network(imageUrl, fit: BoxFit.cover)),
            ),
            Expanded(
              child: Container(
                child: InkWell(
                  onTap: () {
                    print('ontap');
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
                                address,
                                textAlign: TextAlign.start,
                                style: TextStyle(color: Colors.white70),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              onTap: () {
                                print('cross');
                              },
                              child: Icon(
                                Icons.cancel,
                                color: Colors.white70,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: FlatButton.icon(
                            onPressed: () {
                              print(streamUrl);
                              if (category == 'Youtube') {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => YtVideoPlayerPage(
                                              url: streamUrl,
                                            )));
                              } else {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ServerVideoPlayer(
                                              url: streamUrl,
                                            )));
                              }
                            },
                            icon: Icon(
                              Icons.play_arrow,
                              color: Colors.white70,
                            ),
                            label: Text(
                              'Play',
                              style: TextStyle(
                                color: Colors.white70,
                              ),
                            )),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  GestureDetector marker(
      {String imageUrl, camTitle, address, streamUrl, country}) {
    return GestureDetector(
      onTap: () {
        print(address);
        setState(() {
          currentlySelectedPin = Cams(
            address: address,
            camTitle: camTitle,
            imageUrl: imageUrl,
            streamUrl: streamUrl,
            country: country,
          );
          pinPillPosition = 0;
//                _buildMarkersOnMap();
        });
      },
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        child: Container(
          width: 30,
          height: 30,
          color: Color(0xff212121),
          child: CachedNetworkImage(
            fit: BoxFit.cover,
            imageUrl: imageUrl,
            placeholder: (context, url) => Center(
                child: Shimmer.fromColors(
              child: Container(),
              baseColor: Colors.grey[300],
              highlightColor: Colors.grey[100],
            )),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
        ),
      ),
    );
  }

  FlutterMap _buildMap() {
    return FlutterMap(
        options: new MapOptions(
          maxZoom: 15.0,
          minZoom: 7.0,
          center: _center,
          interactive: true,
        ),
        mapController: _mapController,
        layers: [
          TileLayerOptions(
//              urlTemplate:
//              "https://cartodb-basemaps-{s}.global.ssl.fastly.net/dark_all/{z}/{x}/{y}.png",
//              subdomains: ['a', 'b', 'c'],
            urlTemplate:
                "https://api.mapbox.com/styles/v1/loredana/cjwhjt50d005k1dplt10c8e5r/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoibG9yZWRhbmEiLCJhIjoiY2p1dXk3ZHl4MG53OTN5bWhxZjYxYzJodSJ9.TyqzGK0TjNAIDF6B5FwNyA",
            additionalOptions: {
              'accessToken':
                  'pk.eyJ1IjoibG9yZWRhbmEiLCJhIjoiY2p1dXk3ZHl4MG53OTN5bWhxZjYxYzJodSJ9.TyqzGK0TjNAIDF6B5FwNyA',
              'id': 'mapbox.mapbox-streets-v8'
            },
          ),
          MarkerLayerOptions(markers: _buildMarkersOnMap(),),
//          MarkerLayerOptions(markers: _buildMarkersOnMap()),
        ]);
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
          'Camera World',
          style:
              GoogleFonts.righteous(fontSize: 30, color: AppColor.kThemeColor),
        ),
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
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
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
        ],
        leading: Icon(Icons.camera,color: AppColor.kThemeColor,size: 30,),
      ),
      body: Stack(
        children: <Widget>[
          _buildMap(),
          MapPinPillComponent(
              pinPillPosition: pinPillPosition,
              currentlySelectedPin: currentlySelectedPin),
          Positioned(
            right: 0,
            top: 10,
            child: FloatingActionButton(
              backgroundColor: Colors.black38,
              onPressed: getCurrentLocation,
              child: Icon(
                Icons.location_on,
                color: AppColor.kThemeColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

//  void mapCreated(controller) {
//    setState(() {
//      _controller = controller;
//      setMapPins();
//    });
//  }

//  moveCamera(GeoPoint geoPoint) {
//    _controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
//        target: LatLng(geoPoint.latitude, geoPoint.longitude),
//        zoom: 14.0,
//        bearing: 45.0,
//        tilt: 45.0)));
//  }
}
