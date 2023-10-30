import 'dart:io';

import 'package:favorite_places/places/data/models/place_model.dart';
import 'package:favorite_places/places/presentation/bloc/place_bloc.dart';
import 'package:favorite_places/places/presentation/pages/fav_places_info.dart';
import 'package:favorite_places/places/presentation/pages/new_place_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class FavoritePlacesGridTile extends StatefulWidget {
  final PlaceModel placeModel;
  const FavoritePlacesGridTile({super.key, required this.placeModel});

  @override
  State<FavoritePlacesGridTile> createState() => _FavoritePlacesGridTileState();
}

class _FavoritePlacesGridTileState extends State<FavoritePlacesGridTile> {
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(widget.placeModel.id),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        FavPlacesInfoPage(placeModel: widget.placeModel)));
          },
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: FileImage(File(widget.placeModel.imageUrl)),
                radius: 30,
              ),
              const SizedBox(
                width: 16,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.placeModel.placeName,
                      style: TextStyle(
                          color: Color(0xff2d232e),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'UbuntuCondensed-Regular'),
                    ),
                    Text(
                      '${widget.placeModel.address.first['country']}, ${widget.placeModel.address.first['street']}, ${widget.placeModel.address.first['name']} ',
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 16,
                        fontFamily: 'UbuntuCondensed-Regular',
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      onDismissed: (direction) {
        print(direction);
        if (direction == DismissDirection.endToStart) {
          context
              .read<PlaceBloc>()
              .add(DeletePlace(placeModel: widget.placeModel));
        }
        if (direction == DismissDirection.startToEnd) {
          context
              .read<PlaceBloc>()
              .add(DeletePlace(placeModel: widget.placeModel));
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const NewPlacePage()));
        }
      },
    );
  }
}