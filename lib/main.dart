import 'dart:collection';
import 'package:easy_localization/easy_localization.dart';
import 'package:favorite_places/places/data/data_source/place_local_ds.dart';
import 'package:favorite_places/places/presentation/bloc/place_bloc.dart';
import 'package:favorite_places/places/presentation/pages/new_place_page.dart';
import 'package:favorite_places/places/presentation/pages/map_page.dart';
import 'package:favorite_places/user/data/data_source/sign_up_local_ds.dart';
import 'package:favorite_places/user/data/models/user_model.dart';
import 'package:favorite_places/user/presentation/bloc/user_bloc.dart';
import 'package:favorite_places/user/presentation/pages/login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  UserModel userModel =
      UserModel(password: '123456789', email: 'aya@gmail.com');
  // AuthinticationRemoteDsImpl().signUp(userModel);
  //await AuthinticationRemoteDsImpl().signIn(userModel);
  // await AuthinticationRemoteDsImpl().signOut();
  print(Firebase.apps.first);
  runApp(MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => UserBloc(AuthinticationRemoteDsImpl())),
        BlocProvider(create: (_) => PlaceBloc(PlaceLocalDsImpl()))
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