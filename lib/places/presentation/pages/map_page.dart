import 'dart:async';
import 'dart:collection';

import 'package:favorite_places/places/presentation/pages/new_place_page.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapSample extends StatefulWidget {
  const MapSample({super.key});

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  var markers = HashSet<Marker>();
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  // var lat;
  // var long;
  late LatLng latLngg;
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  static const CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  @override
  Widget build(BuildContext context) {
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
        alignment: Alignment.bottomCenter,
        children: [
          GoogleMap(
            mapType: MapType.hybrid,
            initialCameraPosition: _kGooglePlex,
            onTap: (LatLng latLng) {
              // Handle the tap event to get the latitude and longitude
              setState(() {
                latLngg = latLng;
                markers.clear(); // Clear previous markers
                markers.add(
                  Marker(
                    markerId: const MarkerId('1'),
                    position: latLng,
                  ),
                );
              });
              print(
                  "Latitude: ${latLng.latitude}, Longitude: ${latLng.latitude}");
            },
            // onMapCreated: (GoogleMapController controller) {
            // setState(() {
            //   markers.add(Marker(
            //       markerId: MarkerId('1'),
            //       position: LatLng(latLngg.latitude, latLngg.longitude)));
            // });
            // },
            markers: markers,
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context, latLngg);
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
          )
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