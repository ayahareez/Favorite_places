import 'package:favorite_places/places/presentation/bloc/place_bloc.dart';
import 'package:favorite_places/places/presentation/pages/new_place_page.dart';
import 'package:favorite_places/places/presentation/widgets/fav_places_grid_tile.dart';
import 'package:favorite_places/user/presentation/bloc/user_bloc.dart';
import 'package:favorite_places/user/presentation/pages/signup_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class FavoritePlacesPage extends StatefulWidget {
  const FavoritePlacesPage({super.key});

  @override
  State<FavoritePlacesPage> createState() => _FavoritePlacesPageState();
}

class _FavoritePlacesPageState extends State<FavoritePlacesPage> {
  @override
  void initState() {
    super.initState();
    context.read<PlaceBloc>().add(GetPlace());
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
                context.read<UserBloc>().add(LogOut());
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SignUpPage()));
              },
              icon: Icon(Icons.logout))
        ],
      ),
      body: BlocBuilder<PlaceBloc, PlaceState>(
        builder: (context, state) {
          if (state is PlaceLoading) {
            return Center(child: CircularProgressIndicator());
          }
          if (state is PlaceLoaded) {
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemBuilder: (_, i) => FavoritePlacesGridTile(
                      placeModel: state.places[i],
                    ),
                    itemCount: state.places.length,
                  ),
                ),
              ],
            );
          }
          return Center(
              child: Text(
            'searching',
            style: TextStyle(color: Colors.white, fontSize: 22),
          ));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => NewPlacePage()));
        },
        child: Icon(
          Icons.add,
          color: Color(0xfff0a6ca),
        ),
        backgroundColor: Color(0xff2d232e),
      ),
    );
  }
}