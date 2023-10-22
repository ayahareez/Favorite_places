import 'dart:io';
import 'package:favorite_places/places/data/models/place_model.dart';
import 'package:favorite_places/places/presentation/bloc/place_bloc.dart';
import 'package:favorite_places/places/presentation/pages/fav_places_page.dart';
import 'package:favorite_places/places/presentation/pages/map_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';

//UbuntuCondensed-Regular
class NewPlacePage extends StatefulWidget {
  final LatLng latLng;

  const NewPlacePage({super.key, required this.latLng});
  @override
  State<NewPlacePage> createState() => _NewPlacePageState();
}

class _NewPlacePageState extends State<NewPlacePage> {
  bool flag = false;
  File? imageFile;
  var currentLocation;
  List<Placemark> placemarks = [];
  TextEditingController title = TextEditingController();
  var fromKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add New Place',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
              fontFamily: 'UbuntuCondensed-Regular'),
        ),
      ),
      body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        return Container(
          width: double.infinity,
          padding: EdgeInsetsDirectional.all(16),
          child: SingleChildScrollView(
            child: Form(
              key: fromKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: title,
                    decoration: InputDecoration(
                        labelText: 'Title',
                        labelStyle: TextStyle(
                            color: Color(0xfffb6f92),
                            fontWeight: FontWeight.bold,
                            fontSize: 18)),
                    validator: (value) {
                      if (value!.isEmpty) return 'Name Must Be Enered';
                    },
                  ),
                  SizedBox(
                    height: 32,
                  ),
                  Container(
                      width: constraints.maxWidth / 1.1,
                      height: constraints.maxWidth / 1.3,
                      child: flag
                          ? Image.file(
                              File(imageFile!.path),
                              fit: BoxFit.cover,
                            )
                          : TextButton(
                              onPressed: () async {
                                imageFile = await getImage(ImageSource.camera);
                                setState(() {
                                  flag = true;
                                });
                              },
                              child: Text(
                                'Take Photo',
                                style: TextStyle(
                                    color: Color(0xff2d232e),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22),
                              ))),
                  SizedBox(
                    height: 16,
                  ),
                  SizedBox(
                    height: 180,
                    child: Image.network(
                      'https://images.unsplash.com/photo-1524661135-423995f22d0b?auto=format&fit=crop&q=60&w=500&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Nnx8bWFwfGVufDB8fDB8fHww',
                      width: constraints.maxWidth,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Icon(
                              Icons.location_on_rounded,
                              color: Color(0xfff0a6ca),
                            ),
                            TextButton(
                                onPressed: () async {
                                  currentLocation = await getCurrentPosition();
                                  print(currentLocation);
                                  double latitude = currentLocation.latitude;
                                  double longitude = currentLocation.longitude;
                                  print(longitude);
                                  print(latitude);
                                  placemarks = await placemarkFromCoordinates(
                                      latitude, longitude);
                                  print(placemarks);
                                },
                                child: Text(
                                  'Get Current Location',
                                  style: TextStyle(color: Color(0xff2d232e)),
                                ))
                          ],
                        ),
                      ),
                      Expanded(
                        child: Row(
                          children: [
                            Icon(Icons.map, color: Color(0xfff0a6ca)),
                            TextButton(
                                onPressed: () async {
                                  placemarks = await placemarkFromCoordinates(
                                      widget.latLng.latitude,
                                      widget.latLng.longitude);
                                  print(placemarks);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => MapSample()));
                                },
                                child: Text(
                                  'Select On map ',
                                  style: TextStyle(color: Color(0xff2d232e)),
                                )),
                          ],
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {
                      PlaceModel placeModel = PlaceModel(
                          location: placemarks,
                          placeName: title.text,
                          image: imageFile!.path);
                      context
                          .read<PlaceBloc>()
                          .add(SetPlace(placeModel: placeModel));
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => FavoritePlacesPage()));
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.add, size: 18, color: Color(0xfff0a6ca)),
                        Text(
                          'add place',
                          style:
                              TextStyle(color: Color(0xfff0a6ca), fontSize: 18),
                        ),
                      ],
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xff2d232e),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      }),
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

Future<File?> getImage(ImageSource source) async {
  XFile? xFile = await ImagePicker().pickImage(source: source);
  if (xFile != null) {
    return File(xFile.path);
  } else {
    return null;
  }
}