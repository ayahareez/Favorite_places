import 'dart:io';

import 'package:favorite_places/places/data/models/place_model.dart';
import 'package:flutter/material.dart';

class FavPlacesInfoPage extends StatelessWidget {
  final PlaceModel placeModel;

  const FavPlacesInfoPage({super.key, required this.placeModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(placeModel.placeName),
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: FileImage(File(placeModel.image)),
                fit: BoxFit.cover, // Adjust as needed
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(
                      'https://images.unsplash.com/photo-1524661135-423995f22d0b?auto=format&fit=crop&q=60&w=500&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Nnx8bWFwfGVufDB8fDB8fHww'),
                  radius: 50,
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  '${placeModel.location.join()}',
                  style: TextStyle(color: Colors.black, fontSize: 16),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}