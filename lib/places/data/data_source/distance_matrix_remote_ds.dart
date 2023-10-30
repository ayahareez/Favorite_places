import 'dart:convert';
import '../models/distance_time_model.dart';
import 'package:http/http.dart';

abstract class DistanceRemoteDs {
  Future<DistanceTimeModel> getDistanceTime(
      String origins, String destinations);
}

class DistanceRemoteDsImpl extends DistanceRemoteDs {
  final String baseUrl =
      'https://maps.googleapis.com/maps/api/distancematrix/json';

  @override
  Future<DistanceTimeModel> getDistanceTime(
      String origins, String destinations) async {
    final Uri url = Uri.parse(
        '$baseUrl?origins=$origins&destinations=$destinations&key=AIzaSyDi-bSYjtEknQ7O7V05Hg7oWRLWPnU0rXU');

    final response = await get(url);
    print(response.body);
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      if (data['status'] == 'OK') {
        final element = data['rows'][0]['elements'][0];
        if (element['status'] == 'OK') {
          // final distanceText = element['distance']['text'];
          // final durationText = element['duration']['text'];
          //
          // // Create and return a DistanceTimeModel instance
          // final distanceTimeModel = DistanceTimeModel(
          //   distance: distanceText,
          //   duration: durationText,
          // );
          DistanceTimeModel distanceTimeModel =
              DistanceTimeModel.fromMap(element);
          print('hello');
          print(distanceTimeModel.duration);
          return distanceTimeModel;
        }
      }
    }

    // Handle errors or return an appropriate response as needed
    return throw Exception('api can not be accessed');
  }
}