import 'dart:async';
import 'dart:collection';

import 'package:favorite_places/places/data/data_source/distance_matrix_remote_ds.dart';
import 'package:favorite_places/places/data/models/distance_time_model.dart';
import 'package:favorite_places/places/presentation/pages/new_place_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapSample extends StatefulWidget {
  final double latitude, longitude;
  const MapSample({super.key, required this.latitude, required this.longitude});

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  var markers = HashSet<Marker>();
  late LatLng latLngg;
  Map<PolylineId, Polyline> polylines = {};
  BitmapDescriptor customIcon =
      BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow);
  late DistanceTimeModel distanceTimeModel =
      DistanceTimeModel(distance: '', duration: '');

  @override
  Widget build(BuildContext context) {
    markers.add(Marker(
        markerId: const MarkerId('2'),
        position: LatLng(widget.latitude, widget.longitude)));
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pick Your Location'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pop(context, latLngg);
              },
              icon: const Icon(Icons.save))
        ],
      ),
      body: Stack(
        //alignment: Alignment.bottomCenter,
        children: [
          GoogleMap(
            mapType: MapType.hybrid,
            initialCameraPosition: CameraPosition(
              target: LatLng(widget.latitude, widget.longitude),
              zoom: 10,
            ),
            onTap: (LatLng latLng) async {
              setState(() {
                latLngg = latLng;
                markers.clear;
                // markers.add(Marker(
                //     markerId: const MarkerId('2'),
                //     position: LatLng(widget.latitude, widget.longitude)));
                markers.add(
                  Marker(
                      markerId: const MarkerId('1'),
                      position: latLng,
                      icon: customIcon),
                );
              });
              distanceTimeModel = await DistanceRemoteDsImpl().getDistanceTime(
                  '${widget.latitude},${widget.longitude}',
                  '${latLng.latitude},${latLng.longitude}');

              PolylinePoints polylinePoints = PolylinePoints();

              LatLng startPoint = LatLng(widget.latitude, widget.longitude);
              LatLng endPoint = LatLng(latLngg.latitude, latLngg.longitude);

              PolylineResult result =
                  await polylinePoints.getRouteBetweenCoordinates(
                'AIzaSyDi-bSYjtEknQ7O7V05Hg7oWRLWPnU0rXU',
                PointLatLng(startPoint.latitude, startPoint.longitude),
                PointLatLng(endPoint.latitude, endPoint.longitude),
              );

              if (result.status == 'OK') {
                List<PointLatLng> polylineCoordinates = result.points;

                // Create a Polyline and add it to the map
                Polyline polyline = Polyline(
                  polylineId: PolylineId('polyline_id'),
                  color: Colors.red, // Color of the polyline
                  points: polylineCoordinates
                      .map((point) => LatLng(point.latitude, point.longitude))
                      .toList(),
                );

                // Update the state to include the polyline
                setState(() {
                  polylines[PolylineId('polyline_id')] = polyline;
                });
              }
            },
            markers: markers,
            polylines: Set<Polyline>.from(polylines.values),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(
                  context,
                  latLngg,
                );
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff2d232e)),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.save,
                    color: Color(0xfff0a6ca),
                  ),
                  Text(
                    'save',
                    style: TextStyle(color: Color(0xfff0a6ca), fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              padding: EdgeInsets.all(8),
              color: Colors.white.withOpacity(0.5),
              child: Text(
                '${distanceTimeModel.distance}, ${distanceTimeModel.duration}',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.red[800],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Future<Position> getCurrentPosition() async {
  await Geolocator.requestPermission();
  var permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
      return Future.error('Location permissions are denied');
    }
  }
  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately.
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }

  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  return await Geolocator.getCurrentPosition();
}