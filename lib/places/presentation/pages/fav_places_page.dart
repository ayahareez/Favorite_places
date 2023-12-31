import 'package:favorite_places/places/presentation/bloc/place_bloc.dart';
import 'package:favorite_places/places/presentation/pages/new_place_page.dart';
import 'package:favorite_places/places/presentation/widgets/fav_places_grid_tile.dart';
import 'package:favorite_places/user/presentation/bloc/auth_bloc.dart';
import 'package:favorite_places/user/presentation/pages/login_page.dart';
import 'package:favorite_places/user/presentation/pages/signup_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../user/data/data_source/sign_up_remote_ds.dart';

class FavoritePlacesPage extends StatefulWidget {
  const FavoritePlacesPage({super.key});

  @override
  State<FavoritePlacesPage> createState() => _FavoritePlacesPageState();
}

class _FavoritePlacesPageState extends State<FavoritePlacesPage> {
  @override
  String userId = '';
  void initState() {
    super.initState();
    userId = AuthinticationRemoteDsImpl().getUserId();
    context.read<PlaceBloc>().add(GetAllPlaces());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Favorite Places',
          style: TextStyle(
              fontFamily: 'UbuntuCondensed-Regular',
              fontWeight: FontWeight.bold,
              fontSize: 24),
        ),
        actions: [
          IconButton(
              onPressed: () {
                context.read<AuthBloc>().add(SignOut());
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginPage()));
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      body: BlocBuilder<PlaceBloc, PlaceState>(
        builder: (context, state) {
          if (state is PlaceLoadingState) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is PlaceLoadedState) {
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemBuilder: (_, i) => FavoritePlacesGridTile(
                      placeModel: state.places
                          .where((place) => place.userId == userId)
                          .toList()[i],
                    ),
                    itemCount: state.places
                        .where((place) => place.userId == userId)
                        .toList()
                        .length,
                  ),
                ),
              ],
            );
          }
          return const Center(
              child: Text(
            'searching',
            style: TextStyle(color: Colors.white, fontSize: 22),
          ));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const NewPlacePage()));
        },
        child: const Icon(
          Icons.add,
          color: Color(0xfff0a6ca),
        ),
        backgroundColor: const Color(0xff2d232e),
      ),
    );
  }
}