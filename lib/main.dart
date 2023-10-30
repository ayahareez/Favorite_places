import 'dart:collection';
import 'package:easy_localization/easy_localization.dart';
import 'package:favorite_places/places/data/data_source/distance_matrix_remote_ds.dart';
import 'package:favorite_places/places/data/data_source/place_remote_ds.dart';
import 'package:favorite_places/places/data/data_source/remote_db_helper.dart';
import 'package:favorite_places/places/data/models/place_model.dart';
import 'package:favorite_places/places/presentation/bloc/place_bloc.dart';
import 'package:favorite_places/places/presentation/pages/new_place_page.dart';
import 'package:favorite_places/places/presentation/pages/map_page.dart';
import 'package:favorite_places/places/presentation/pages/location_image_picker.dart';
import 'package:favorite_places/user/data/data_source/sign_up_remote_ds.dart';
import 'package:favorite_places/user/data/models/user_model.dart';
import 'package:favorite_places/user/presentation/bloc/auth_bloc.dart';
import 'package:favorite_places/user/presentation/pages/login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  AuthModel userModel =
      AuthModel(password: '123456789', email: 'aya@gmail.com');
  List<dynamic> add = [];
  PlaceModel placeM = PlaceModel(
    address: add,
    placeName: 'place',
    imageUrl: 'imageUrl',
    id: '1S5ydNjhyRGnTwhgJ6NG',
    userId: 'userId',
    longitude: 0.2158,
    latitude: 0.021457,
  );
  final String origins = '40.6655101,-73.89188969999998';
  final String destinations =
      '40.659569,-73.933783|40.729029,-73.851524|40.6860072,-73.6334271|40.598566,-73.7527626';
  DistanceRemoteDsImpl().getDistanceTime(origins, destinations);
  // await PlaceRemoteDsImpl(remoteDbHelper: RemoteDbHelperImpl())
  //     .setPLace(placeM);
  //await PlaceLocalDsImpl().updatePlace(placeM);
  //await PlaceLocalDsImpl().deletePlace('1S5ydNjhyRGnTwhgJ6NG');
  // AuthinticationRemoteDsImpl().signUp(userModel);
  //await AuthinticationRemoteDsImpl().signIn(userModel);
  // await AuthinticationRemoteDsImpl().signOut();
  List<PlaceModel> places =
      await PlaceRemoteDsImpl(remoteDbHelper: RemoteDbHelperImpl())
          .getAllPlaces();
  print(places);
  print(Firebase.apps.first);
  runApp(MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthBloc(AuthinticationRemoteDsImpl())),
        BlocProvider(
            create: (_) => PlaceBloc(
                PlaceRemoteDsImpl(remoteDbHelper: RemoteDbHelperImpl())))
      ],
      child: EasyLocalization(
          supportedLocales: [const Locale('en'), const Locale('ar')],
          path: 'assets/translations',
          fallbackLocale: const Locale('en'),
          startLocale: const Locale('en'),
          child: const MyApp())));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        theme: ThemeData(
          textTheme: const TextTheme(
            bodyLarge: TextStyle(color: Color(0xffedede9)),
            bodyMedium: TextStyle(color: Color(0xffedede9)),
            displayLarge: TextStyle(
              color: Colors.blue,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xff212529),
              foregroundColor: Color(0xffedede9)),
          colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.deepPurple,
              background: const Color(0xff565264)),
          useMaterial3: true,
        ),
        home: LoginPage());
  }
}