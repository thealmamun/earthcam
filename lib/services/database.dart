import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:earth_cam/model/cams.dart';

// collection reference
final CollectionReference mapCollection = Firestore.instance.collection('maps');

// map data from snapshots
List<Cams> mapDataFromSnapshot(QuerySnapshot snapshot) {
  return snapshot.documents.map((doc){
    return Cams(
      camTitle: doc.data['camTitle'],
      address: doc.data['address'],
      description: doc.data['description'],
      imageUrl: doc.data['imageUrl'],
      createdAt: doc.data['createdAt'],
      category: doc.data['category'],
      streamUrl: doc.data['streamUrl'],
      subCategory: doc.data['subCategory'],
      updatedAt: doc.data['updatedAt'],
      position: doc.data['position'],
      geoPoint: doc.data['position']['geopoint'],
      latLng: doc.data['position']['geopoing']
    );
  }).toList();
}

// get map doc stream
Stream<List<Cams>> get mapData {
  return mapCollection.snapshots()
      .map(mapDataFromSnapshot);
}

searchByName(String searchField) {
  return Firestore.instance
      .collection('maps')
      .where('searchKey',
      isEqualTo: searchField.substring(0, 1).toUpperCase())
      .getDocuments();
}