import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:earth_cam/model/cams.dart';
import 'package:earth_cam/services/database.dart';
import 'package:earth_cam/widgets/map_pin_pill.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapView extends StatefulWidget {
  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  GoogleMapController _controller;
//  Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _markers = {};
  PageController _pageController;
  int prevPage;
  bool isClicked = false;
  List<Cams> cams = List<Cams>();
  Stream dataList;
  bool liveCamMaps;
  BitmapDescriptor markerIcon;
  double pinPillPosition = -100;
//  PinInformation currentlySelectedPin = PinInformation(
//      pinPath: ‘’,
//      avatarPath: ‘’,
//      location: LatLng(0, 0),
//      locationName: ‘’,
//      labelColor: Colors.grey);
//  PinInformation sourcePinInfo;
  Cams currentlySelectedPin = Cams(
      address: '',
      camTitle: '',
      geoPoint: GeoPoint(0.0,0.0),
      imageUrl: '',
      streamUrl: '',
      category: '',
  );
  Cams camInfo;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    liveCamMaps = false;
//    print(cams.camTitle);
//    screenMarker();
    dataList = Firestore.instance.collection('maps')
        .where('category', isEqualTo: 'Live Cams').orderBy('createdAt')
        .snapshots();
    setSourceAndDestinationIcons();
    _pageController = PageController(initialPage: 1, viewportFraction: 0.8,keepPage: false)
      ..addListener(_onScroll);
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

  void _onScroll() {
    if (_pageController.page.toInt() != prevPage) {
      prevPage = _pageController.page.toInt();
//      moveCamera();
    }
  }

//  Widget _mapsList(index, DocumentSnapshot documentSnapshot) {
//    return AnimatedBuilder(
//      animation: _pageController,
//      builder: (BuildContext context, Widget widget) {
//        double value = 1;
//        if (_pageController.position.haveDimensions) {
//          value = _pageController.page - index;
//          value = (1 - (value.abs() * 0.3) + 0.06).clamp(0.0, 1.0);
//        }
//        return Center(
//          child: SizedBox(
////            height: Curves.easeInOut.transform(value) * 125.0,
////            width: Curves.easeInOut.transform(value) * 350.0,
//            height: 120.0,
//            width: 300.0,
//            child: widget,
//          ),
//        );
//      },
//      child: InkWell(
//        onTap: () {
//          moveCamera(documentSnapshot.data['position']['geopoint']);
//        },
//        child: Stack(
//          children: [
//            Container(
//              margin: EdgeInsets.symmetric(
//                horizontal: 10.0,
//                vertical: 20.0,
//              ),
//              decoration: BoxDecoration(
//                  borderRadius: BorderRadius.circular(10.0),
//                  color: Colors.white,
//                  boxShadow: [
//                    BoxShadow(
//                      color: Colors.black54,
//                      offset: Offset(0.0, 4.0),
//                      blurRadius: 10.0,
//                    ),
//                  ]),
//              child: Row(
//                children: [
//                  CachedNetworkImage(
//                    fit: BoxFit.fill,
//                    imageUrl: documentSnapshot.data['imageUrl'],
//                    placeholder: (context, url) => CircularProgressIndicator(),
//                    errorWidget: (context, url, error) => Icon(Icons.error),
//                  ),
//                  SizedBox(width: 5.0),
//                  Expanded(
//                    child: Column(
//                      crossAxisAlignment: CrossAxisAlignment.start,
//                      children: [
//                        Expanded(
//                          child: Text(
//                            documentSnapshot.data['camTitle'],
//                            style: TextStyle(
//                                fontSize: 12.5, fontWeight: FontWeight.bold),
//                          ),
//                        ),
//                        Expanded(
//                          child: Text(
//                            documentSnapshot.data['address'],
//                            style: TextStyle(
//                                fontSize: 12.0, fontWeight: FontWeight.w600),
//                          ),
//                        ),
//                        Expanded(
//                          child: Container(
//                            width: 100,
//                            child: RaisedButton.icon(
//                              elevation: 12,
//                              shape: RoundedRectangleBorder(
//                                borderRadius: new BorderRadius.circular(15),
//                              ),
//                              onPressed: () {
//                                Navigator.push(
//                                    context,
//                                    MaterialPageRoute(
//                                        builder: (context) =>
//                                            ServerVideoPlayer()));
//                              },
//                              icon: Icon(
//                                Icons.play_arrow,
//                                color: Colors.white,
//                              ),
//                              label: Text(
//                                'Play',
//                                style: TextStyle(color: Colors.white),
//                              ),
//                              color: Colors.redAccent,
//                            ),
//                          ),
//                        ),
//                      ],
//                    ),
//                  ),
//                ],
//              ),
//            ),
//          ],
//        ),
//      ),
//    );
//  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFF1B2D45),
        appBar: AppBar(
          centerTitle: true,
          title: Text('All Live Cams'),
          leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: null),
          actions: [
            IconButton(
                icon: Icon(
                  Icons.do_not_disturb_off,
                  color: Colors.white,
                  size: 25,
                ),
                onPressed: null),
          ],
        ),
        body: Stack(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height - 50.0,
              width: MediaQuery.of(context).size.width,
              child: GoogleMap(
                mapType: MapType.hybrid,
                compassEnabled: true,
                mapToolbarEnabled: false,
                zoomControlsEnabled: false,
                myLocationEnabled: true,
                initialCameraPosition: CameraPosition(
                    target: LatLng(40.7128, -74.0060), zoom: 12.0),
                markers: _markers,
                onMapCreated: mapCreated,
                padding: EdgeInsets.only(top: 40.0,),
              ),
            ),
            MapPinPillComponent(
                pinPillPosition: pinPillPosition,
                currentlySelectedPin: currentlySelectedPin
            ),
//            Positioned(
//              bottom: 0.0,
//              child: Container(
//                  height: 200.0,
//                  width: MediaQuery.of(context).size.width,
//                  child: StreamBuilder<QuerySnapshot>(
//                    stream: dataList,
//                    builder: (context, snapshot) {
//                      if (snapshot.hasData) {
//                        return ListView.builder(
//                          controller: _pageController,
//                          scrollDirection: Axis.horizontal,
//                          itemBuilder: (BuildContext context, int index) {
//                            return Row(
//                              children: snapshot.data.documents
//                                  .map((doc) => _mapsList(index, doc))
//                                  .toList(),
//                            );
//                          },
//                        );
//                      } else
//                        return Center(child: CircularProgressIndicator());
//                    },ß
//                  )),
//            ),
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
                          dataList =  Firestore.instance.collection('maps')
                              .where('category', isEqualTo: 'YouTube').orderBy('createdAt')
                              .snapshots();
                        });
//                        Navigator.push(
//                            context,
//                            MaterialPageRoute(
//                                builder: (context) => YtVideoPlayerPage()));
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
                          dataList =  Firestore.instance.collection('maps')
                              .where('category', isEqualTo: 'Live Cams').orderBy('createdAt')
                              .snapshots();
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
        ));
  }

  void mapCreated(controller) {
    setState(() {
      _controller = controller;
      setMapPins();
    });
  }

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
