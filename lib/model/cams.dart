import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Cams {
  String camTitle;
  String address;
  String streamUrl;
  String category;
  String camType;
  String createdAt;
  String updatedAt;
  String description;
  String imageUrl;
  Map<String,dynamic> position;
  GeoPoint geoPoint;
  LatLng latLng;

  Cams(
      {this.camTitle,
        this.address,
        this.description,
        this.imageUrl,
        this.createdAt,
        this.position,
        this.category,
        this.streamUrl,
        this.camType,
        this.updatedAt,
        this.geoPoint,
        this.latLng,
      });
}
