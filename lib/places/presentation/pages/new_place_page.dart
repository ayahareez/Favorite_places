import 'dart:io';
import 'package:favorite_places/places/data/data_source/place_remote_ds.dart';
import 'package:favorite_places/places/data/models/place_model.dart';
import 'package:favorite_places/places/presentation/bloc/place_bloc.dart';
import 'package:favorite_places/places/presentation/pages/fav_places_page.dart';
import 'package:favorite_places/places/presentation/pages/map_page.dart';
import 'package:favorite_places/user/data/data_source/sign_up_remote_ds.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_static_maps_controller/google_static_maps_controller.dart'
    as gmaps;
import 'package:image_picker/image_picker.dart';

//UbuntuCondensed-Regular
class NewPlacePage extends StatefulWidget {
  const NewPlacePage({super.key});
  @override
  State<NewPlacePage> createState() => _NewPlacePageState();
}

class _NewPlacePageState extends State<NewPlacePage> {
  late ImageProvider image;

  bool flag = false;
  File? imageFile;
  late Position currentLocation;
  List<Placemark> placemarks = [];
  LatLng? latLng;
  TextEditingController title = TextEditingController();
  var fromKey = GlobalKey<FormState>();
  String userId = '';
  var current;
  @override
  initState() {
    super.initState();
    userId = AuthinticationRemoteDsImpl().getUserId();
  }

  @override
  Widget build(BuildContext context) {
    if (latLng != null) {
      var _controller = gmaps.StaticMapController(
        googleApiKey: "AIzaSyDi-bSYjtEknQ7O7V05Hg7oWRLWPnU0rXU",
        width: 400,
        height: 400,
        zoom: 10,
        center: gmaps.Location(latLng!.latitude, latLng!.longitude),
      );
      image = _controller.image;
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text(
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
          padding: const EdgeInsetsDirectional.all(16),
          child: SingleChildScrollView(
            child: Form(
              key: fromKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: title,
                    decoration: const InputDecoration(
                        labelText: 'Title',
                        labelStyle: TextStyle(
                            color: Color(0xfffb6f92),
                            fontWeight: FontWeight.bold,
                            fontSize: 18)),
                    validator: (value) {
                      if (value!.isEmpty) return 'Name Must Be Entered';
                    },
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  Container(
                      width: constraints.maxWidth / 1.1,
                      height: constraints.maxWidth / 1.8,
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
                              child: const Text(
                                'Take Photo',
                                style: TextStyle(
                                    color: Color(0xff2d232e),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22),
                              ))),
                  const SizedBox(
                    height: 16,
                  ),
                  SizedBox(
                    height: 200,
                    child: Image(
                      image: latLng != null
                          ? image
                          : NetworkImage(
                              'https://images.unsplash.com/photo-1524661135-423995f22d0b?auto=format&fit=crop&q=60&w=500&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Nnx8bWFwfGVufDB8fDB8fHww'),
                      width: constraints.maxWidth,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Row(
                    children: [
                      SizedBox(
                        height: 100,
                        child: TextButton(
                            onPressed: () async {
                              current = await getCurrentPosition();
                              latLng = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MapSample(
                                            latitude: current.latitude,
                                            longitude: current.longitude,
                                          )));
                              placemarks = await placemarkFromCoordinates(
                                  latLng!.latitude, latLng!.longitude);
                              print(placemarks);
                              setState(() {});
                            },
                            child: const Row(
                              children: [
                                Icon(Icons.map, color: Color(0xfff0a6ca)),
                                Text(
                                  'Select On Map ',
                                  style: TextStyle(
                                      color: Color(0xff2d232e), fontSize: 16),
                                ),
                              ],
                            )),
                      ),
                      SizedBox(
                        height: 100,
                        child: TextButton(
                            onPressed: () async {
                              currentLocation = await getCurrentPosition();
                              print(currentLocation);
                              latLng = LatLng(currentLocation.latitude,
                                  currentLocation.longitude);
                              double latitude = currentLocation.latitude;
                              double longitude = currentLocation.longitude;
                              print(longitude);
                              print(latitude);
                              placemarks = await placemarkFromCoordinates(
                                  latitude, longitude);
                              print(placemarks);
                              setState(() {});
                            },
                            child: const Row(
                              children: [
                                Icon(
                                  Icons.location_on_rounded,
                                  color: Color(0xfff0a6ca),
                                ),
                                Text(
                                  'Get Current Location',
                                  style: TextStyle(
                                      color: Color(0xff2d232e), fontSize: 16),
                                ),
                              ],
                            )),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (placemarks.isNotEmpty) {
                        final place = placemarks.first;
                        PlaceModel placeModel = PlaceModel(
                          address: placemarks.map((placemark) {
                            return {
                              'name': placemark.name,
                              'thoroughfare': placemark.thoroughfare,
                              'subThoroughfare': placemark.subThoroughfare,
                              'locality': placemark.locality,
                              'subLocality': placemark.subLocality,
                              'administrativeArea':
                                  placemark.administrativeArea,
                              'subAdministrativeArea':
                                  placemark.subAdministrativeArea,
                              'postalCode': placemark.postalCode,
                              'country': placemark.country,
                              'isoCountryCode': placemark.isoCountryCode,
                              'street': placemark.street
                            };
                          }).toList(),
                          placeName: title.text,
                          imageUrl: imageFile!.path,
                          id: '',
                          userId: userId,
                          longitude: latLng!.longitude,
                          latitude: latLng!.latitude,
                        );
                        print(placeModel.longitude);
                        print(placeModel.userId);
                        context
                            .read<PlaceBloc>()
                            .add(SetPlace(placeModel: placeModel));
                      }

                      //print(await PlaceRemoteDsImpl().getAllPlaces());
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const FavoritePlacesPage()));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff2d232e),
                    ),
                    child: const Row(
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