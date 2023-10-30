import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:favorite_places/places/data/data_source/remote_db_helper.dart';
import 'package:favorite_places/places/data/models/place_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class PlaceRemoteDs {
  Future<void> setPLace(PlaceModel placeModel);

  Future<List<PlaceModel>> getAllPlaces();

  Future<void> deletePlace(String id);

  Future<void> updatePlace(PlaceModel placeModel);
}

class PlaceRemoteDsImpl extends PlaceRemoteDs {
  String collectionName = 'places';
  RemoteDbHelper remoteDbHelper;
  PlaceRemoteDsImpl({required this.remoteDbHelper});
  @override
  Future<List<PlaceModel>> getAllPlaces() async {
    return List<PlaceModel>.from(
        await remoteDbHelper.get(collectionName, PlaceModel.fromDoc));
    // final snapshot =
    //     await FirebaseFirestore.instance.collection('places').get();
    // return snapshot.docs.map((e) => PlaceModel.fromDoc(e)).toList();
  }

  @override
  Future<void> setPLace(PlaceModel placeModel) =>
      remoteDbHelper.add(collectionName, placeModel.toMap());

  @override
  Future<void> updatePlace(PlaceModel placeModel) =>
      remoteDbHelper.update(collectionName, placeModel.id, placeModel.toMap());

  @override
  Future<void> deletePlace(String id) =>
      remoteDbHelper.delete(collectionName, id);
}