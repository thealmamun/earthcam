import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:earth_cam/model/cams.dart';
import 'package:earth_cam/pages/general_video_player.dart';
import 'package:earth_cam/pages/youtube_video_player.dart';
import 'package:earth_cam/services/database.dart';
import 'package:earth_cam/utils/app_configure.dart';
import 'package:earth_cam/utils/constants.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

import 'package:location/location.dart';
import 'package:shimmer/shimmer.dart';

class MapViewNew extends StatefulWidget {
  @override
  _MapViewNewState createState() => _MapViewNewState();
}

class _MapViewNewState extends State<MapViewNew> with TickerProviderStateMixin {
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

  void _animatedMapMove(LatLng destLocation, double destZoom) {
    // Create some tweens. These serve to split up the transition from one location to another.
    // In our case, we want to split the transition be<tween> our current map center and the destination.
    final _latTween = Tween<double>(
        begin: _mapController.center.latitude, end: destLocation.latitude);
    final _lngTween = Tween<double>(
        begin: _mapController.center.longitude, end: destLocation.longitude);
    final _zoomTween = Tween<double>(begin: _mapController.zoom, end: destZoom);

    // Create a animation controller that has a duration and a TickerProvider.
    var controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    // The animation determines what path the animation will take. You can try different Curves values, although I found
    // fastOutSlowIn to be my favorite.
    Animation<double> animation =
        CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn);

    controller.addListener(() {
      _mapController.move(
          LatLng(_latTween.evaluate(animation), _lngTween.evaluate(animation)),
          _zoomTween.evaluate(animation));
    });
    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.dispose();
      } else if (status == AnimationStatus.dismissed) {
        controller.dispose();
      }
    });
    controller.forward();
  }

  getCurrentLocation() async {
    Location location = new Location();
    LocationData _locationData;
    _locationData = await location.getLocation();
    setState(() {
      _animatedMapMove(
          LatLng(_locationData.latitude, _locationData.longitude), 20.0);
    });
  }

  showDebugPrint() {
    debugPrint('Print from Callback Function');
  }

  _buildMarkersOnMap() {
    mapData.forEach((element) {
      for (var i = 0; i < element.length; i++) {
        var marker = Marker(
          height: 50,
          width: 50,
          point: LatLng(
              element[i].geoPoint.latitude, element[i].geoPoint.longitude),
          builder: (context) => GestureDetector(
            onTap: () {
              print(element[i].address);
              _animatedMapMove(
                  LatLng(element[i].geoPoint.latitude,
                      element[i].geoPoint.longitude),
                  20.0);
//              Future.delayed(Duration(seconds: 1), () {
//
//              });
              showGeneralDialog(
                  context: context,
                  // ignore: missing_return
                  pageBuilder: (context, anim1, anim2) {},
                  barrierDismissible: true,
                  barrierColor: Colors.black.withOpacity(0.4),
                  barrierLabel: '',
                  transitionDuration: Duration(milliseconds: 200),
                  transitionBuilder: (context, anim1, anim2, child) {
                    return FadeTransition(
                      opacity: anim1,
                      child: Theme(
                        data: Theme.of(context).copyWith(
                            dialogBackgroundColor: Colors.transparent),
                        child: AlertDialog(
                          contentPadding: EdgeInsets.all(1),
                          content: Container(
                            height: 180,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              color: AppColor.kAppBarBackgroundColor,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                  blurRadius: 30,
                                  spreadRadius: 1,
                                  offset: Offset(0, 5),
                                  color: Colors.grey.withOpacity(0.2),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Expanded(
                                  flex: 4,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        width: 70,
                                        height: 70,
                                        margin:
                                            EdgeInsets.only(left: 10, top: 10),
                                        child: ClipOval(
                                          child: FancyShimmerImage(
                                            boxFit: BoxFit.fill,
                                            imageUrl: element[i].imageUrl,
                                            errorWidget: Icon(Icons.error),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Expanded(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Text(
                                                        element[i].camTitle,
                                                        textAlign:
                                                            TextAlign.start,
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white70),
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: InkWell(
                                                      onTap: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child: Icon(
                                                        Icons.cancel,
                                                        color: Colors.white70,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 8.0),
                                        child: Icon(
                                          Icons.location_on,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            element[i].address,
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                                color: Colors.white70,
                                                fontSize: 15),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      FlatButton.icon(
                                        padding: EdgeInsets.all(5),
                                        onPressed: () {
                                          print(element[i].streamUrl);
                                          if (element[i].camType == 'Youtube') {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    YtVideoPlayerPage(
                                                  url: element[i].streamUrl,
                                                      title: element[i].camTitle,
                                                ),
                                              ),
                                            );
                                          } else {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ServerVideoPlayer(
                                                  url: element[i].streamUrl,
                                                      title: element[i].camTitle,
                                                ),
                                              ),
                                            );
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
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  });
            },
            child: _buildCustomMarker(
              imageUrl: element[i].imageUrl,
              camTitle: element[i].camTitle,
              address: element[i].address,
              streamUrl: element[i].streamUrl,
              country: element[i].country,
              camType: element[i].camType,
            ),
          ),
        );
        markers.add(marker);
        print(marker);
      }
    });
    return markers;
  }

  Container _buildCustomMarker(
      {String imageUrl, camTitle, address, streamUrl, country, camType}) {
    return Container(
      child: marker(
          imageUrl: imageUrl,
          camTitle: camTitle,
          address: address,
          streamUrl: streamUrl,
          country: country),
    );
  }

  Widget marker({String imageUrl, camTitle, address, streamUrl, country}) {
    return ClipRRect(
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
            ),
          ),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
      ),
    );
  }

  FlutterMap _buildMap() {
    return FlutterMap(
      options: new MapOptions(
        maxZoom: 15.0,
        minZoom: 3.5,
        center: _center,
        interactive: true,
      ),
      mapController: _mapController,
      layers: [
        TileLayerOptions(
          backgroundColor: AppColor.kBackgroundColor,
          urlTemplate: AppConfig.mapBoxUrlLink,
          additionalOptions: {
            'accessToken': AppConfig.mapBoxAccessToken,
            'id': 'mapbox.mapbox-streets-v8'
          },
        ),
        MarkerLayerOptions(
          markers: _buildMarkersOnMap(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.kBackgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 10,
        iconTheme: IconThemeData(color: AppColor.kThemeColor),
        centerTitle: true,
        title: SizedBox(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              'Around the World',
              style: AppConfig.appNameStyle,
            ),
          ),
        ),
        backgroundColor: AppColor.kAppBarBackgroundColor,
        actions: [
          AppConfig.appBarSearchButton(context),
        ],
        leading: AppConfig.appLeadingIcon,
      ),
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Positioned.fill(child: _buildMap()),
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
}
