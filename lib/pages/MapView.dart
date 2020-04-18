import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapView extends StatefulWidget {
  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
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
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(23.7209, 90.4833),
          zoom: 12,
        ),
      ),
    );
  }
}
