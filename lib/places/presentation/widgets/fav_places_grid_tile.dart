import 'dart:io';

import 'package:favorite_places/places/data/models/place_model.dart';
import 'package:favorite_places/places/presentation/pages/fav_places_info.dart';
import 'package:favorite_places/places/presentation/pages/new_place_page.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class FavoritePlacesGridTile extends StatelessWidget {
  final PlaceModel placeModel;
  const FavoritePlacesGridTile({super.key, required this.placeModel});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      FavPlacesInfoPage(placeModel: placeModel)));
        },
        child: Row(
          children: [
            CircleAvatar(
              backgroundImage: FileImage(File(placeModel.image)),
              radius: 35,
            ),
            SizedBox(
              width: 16,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    placeModel.placeName,
                    style: TextStyle(
                        color: Color(0xff2d232e),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'UbuntuCondensed-Regular'),
                  ),
                  Text(
                    '${placeModel.location.join()}',
                    style: TextStyle(
                      color: Color(0xfff0a6ca),
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
    );
  }
}