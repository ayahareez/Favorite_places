import 'dart:convert';
import 'package:favorite_places/places/data/models/place_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class PlaceLocalDs{
  Future<void> setPLace(PlaceModel placeModel);
  Future<List<PlaceModel>> getPlaces();
}


class PlaceLocalDsImpl extends PlaceLocalDs{
  String placeKey='place';
  @override
  Future<List<PlaceModel>> getPlaces() async {
    final pref = await SharedPreferences.getInstance();
    List<String> placesJson= pref.getStringList(placeKey)??[];
    List<PlaceModel>  places=[];
    for(int i=0; i<placesJson.length;i++){
      String placeJson=placesJson[i];
      Map<String,dynamic> jsonMap= jsonDecode(placeJson);
      PlaceModel placeModel =PlaceModel.fromMap(jsonMap);
      places.add(placeModel);
    }
    return places;
  }

  @override
  Future<void> setPLace(PlaceModel placeModel) async {
    final pref = await SharedPreferences.getInstance();
    List<String> placesJson= pref.getStringList(placeKey)??[];
    Map<String,dynamic> jsonMap= placeModel.toMap();
    String placeJson=jsonEncode(jsonMap);
    placesJson.add(placeJson);
    pref.remove(placeKey);
    pref.setStringList(placeKey, placesJson);
  }

}