import 'dart:collection';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:ui' as ui;

class MapView extends StatefulWidget {
  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  bool isClicked = false;
  Set<Marker> _markers = HashSet<Marker>();
  GoogleMapController _mapController;
  BitmapDescriptor _markerIcon;



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _setMarkerIcon();
  }

  _setMarkerIcon() async {
    _markerIcon = await BitmapDescriptor.fromAssetImage(ImageConfiguration( ), 'assets/images/dart.png');

  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    setState(() {
      //marker value will come from backend db
      _markers.add(
          Marker(markerId: MarkerId('0'),
          infoWindow: InfoWindow(
            title: 'Mirpara Demra',
                snippet: 'An Intersting City',
            onTap: (){
              print('OnTap');
            }
          ),
          icon: _markerIcon,
          position: LatLng(23.7209, 90.4833)),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Map View'),
          actions: [
            IconButton(
                icon: Icon(
                  Icons.search,
                  color: Colors.white,
                  size: 30,
                ),
                onPressed: null),
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
          children: [
            GoogleMap(
              markers: _markers,
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: LatLng(23.7209, 90.4833),
                zoom: 12,
              ),
            ),
            isClicked
                ? Container(
                    alignment: Alignment.centerRight,
                    child: RaisedButton.icon(
                      elevation: 20,
                      shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            topLeft: Radius.circular(20)),
                      ),
                      onPressed: () {
                        setState(() {
                          isClicked = false;
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
                    alignment: Alignment.centerRight,
                    child: RaisedButton.icon(
                      elevation: 20,
                      shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            topLeft: Radius.circular(20)),
                      ),
                      onPressed: () {
                        setState(() {
                          isClicked = true;
                        });
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
}
