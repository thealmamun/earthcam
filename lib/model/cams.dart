import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Cams {
  int id;
  String camId;
  String camTitle;
  String address;
  String streamUrl;
  String category;
  String camType;
  String createdAt;
  String updatedAt;
  String description;
  String imageUrl;
  Map<String, dynamic> position;
  GeoPoint geoPoint;
  LatLng latLng;

  Cams({
    this.id,
    this.camTitle,
    this.camId,
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

  Map<String, dynamic> toMap() {
    return {
      'camId': camId,
      'camTitle': camTitle,
      'camType': camType,
      'imageUrl': imageUrl,
      'streamUrl': streamUrl,
    };
  }
  Cams.fromMap(Map<String, dynamic> map) {
    camId = map['camId'];
    camTitle = map['camTitle'];
    camType = map['camType'];
    imageUrl = map['imageUrl'];
    streamUrl = map['streamUrl'];
  }
}
