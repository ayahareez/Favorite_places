import 'package:geocoding/geocoding.dart';

class PlaceModel {
  final String placeName, image;
  final List<dynamic> location;
  PlaceModel(
      {required this.location, required this.placeName, required this.image});

  Map<String, dynamic> toMap() =>
      {'placeName': placeName, 'location': location, 'image': image};

  factory PlaceModel.fromMap(Map<String, dynamic> map) => PlaceModel(
      location: map['location'],
      placeName: map['placeName'],
      image: map['image']);
}