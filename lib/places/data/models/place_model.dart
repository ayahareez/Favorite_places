import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geocoding/geocoding.dart';

class PlaceModel {
  final String placeName, imageUrl, id, userId;
  final List<dynamic> address;
  final double latitude, longitude;

  PlaceModel(
      {required this.address,
      required this.placeName,
      required this.imageUrl,
      required this.id,
      required this.userId,
      required this.latitude,
      required this.longitude});
  factory PlaceModel.fromDoc(QueryDocumentSnapshot<Map<String, dynamic>> doc) =>
      PlaceModel(
        address: doc.data()['location'],
        placeName: doc.data()['placeName'],
        imageUrl: doc.data()['imageUrl'],
        id: doc.id,
        userId: doc.data()['userId'],
        latitude: doc.data()['latitude'] ?? 0.0,
        longitude: doc.data()['longitude'] ?? 0.0,
      );
  toMap() => {
        "location": address,
        'placeName': placeName,
        "imageUrl": imageUrl,
        "userId": userId,
        "latitude": latitude,
        "longitude": longitude
      };
}