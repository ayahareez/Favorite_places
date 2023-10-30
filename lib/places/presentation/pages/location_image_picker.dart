import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_static_maps_controller/google_static_maps_controller.dart';

class LocationImagePicker extends StatelessWidget {
  final LatLng latLng;
  const LocationImagePicker({super.key, required this.latLng});
  @override
  Widget build(BuildContext context) {
    /// Declare static map controller
    const _controller = StaticMapController(
      googleApiKey: "AIzaSyDi-bSYjtEknQ7O7V05Hg7oWRLWPnU0rXU",
      width: 400,
      height: 400,
      zoom: 10,
      center: Location(-3.1178833, -60.0029284),
    );

    /// Get map image provider from controller.
    /// You can also get image url by accessing
    /// `_controller.url` property.
    ImageProvider image = _controller.image;

    return Scaffold(
      body: Center(
        /// Display as a normal network image
        child: Image(image: image),
      ),
    );
  }
}