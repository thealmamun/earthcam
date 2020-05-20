// 📦 Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';

// 🌎 Project imports:
import 'package:earth_cam/model/cams.dart';

// collection reference
final CollectionReference mapCollection = Firestore.instance.collection('cams');
final Query youtubeMap = Firestore.instance.collection('cams')
    .where('camType',isEqualTo: 'Youtube');

final Query ipCamMap = Firestore.instance.collection('cams')
    .where('camType',isEqualTo: 'IP Cams');

// map data from snapshots
List<Cams> mapDataFromSnapshot(QuerySnapshot snapshot) {
  return snapshot.documents.map((doc){
    return Cams(
      camId: doc.data['camId'],
      camTitle: doc.data['camTitle'],
      camType: doc.data['camType'],
      address: doc.data['address'],
      description: doc.data['description'],
      imageUrl: doc.data['imageUrl'],
      createdAt: doc.data['createdAt'].toString(),
      country: doc.data['country'],
      streamUrl: doc.data['streamUrl'],
      updatedAt: doc.data['updatedAt'].toString(),
      position: doc.data['position'],
      geoPoint: doc.data['position']['geopoint'],
//      latLng: doc.data['position']['geopoing']
    );
  }).toList();
}

// get map doc stream
Stream<List<Cams>> get mapData {
  return mapCollection.snapshots()
      .map(mapDataFromSnapshot);
}

Stream<List<Cams>> get ytMap {
  return youtubeMap.snapshots()
      .map(mapDataFromSnapshot);
}
Stream<List<Cams>> get ipCam {
  return ipCamMap.snapshots()
      .map(mapDataFromSnapshot);
}

searchByName(String searchField) {
  return Firestore.instance
      .collection('cams')
      .where('searchKey',
      isEqualTo: searchField.substring(0, 1).toUpperCase())
      .getDocuments();
}
