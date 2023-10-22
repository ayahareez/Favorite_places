import 'dart:collection';

import 'package:favorite_places/places/presentation/bloc/place_bloc.dart';
import 'package:favorite_places/places/presentation/pages/new_place_page.dart';
import 'package:favorite_places/places/presentation/pages/test.dart';
import 'package:favorite_places/user/presentation/bloc/user_bloc.dart';
import 'package:favorite_places/user/presentation/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() {
  runApp(MultiBlocProvider(providers: [
    BlocProvider(create: (_) => UserBloc()),
    BlocProvider(create: (_) => PlaceBloc())
  ], child: MyApp()));
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
        title: 'Flutter Demo',
        theme: ThemeData(
          textTheme: TextTheme(
            bodyLarge: TextStyle(color: Color(0xffedede9)),
            bodyMedium: TextStyle(color: Color(0xffedede9)),
            displayLarge: TextStyle(
              color: Colors.blue,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          appBarTheme: AppBarTheme(
              backgroundColor: Color(0xff212529),
              foregroundColor: Color(0xffedede9)),
          colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.deepPurple, background: Color(0xff6d6875)),
          useMaterial3: true,
        ),
        home: LoginPage());
  }
}