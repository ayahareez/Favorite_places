import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:favorite_places/places/data/data_source/place_remote_ds.dart';
import 'package:favorite_places/places/data/models/place_model.dart';
import 'package:meta/meta.dart';

part 'place_event.dart';
part 'place_state.dart';

class PlaceBloc extends Bloc<PlaceEvent, PlaceState> {
  PlaceRemoteDs placeLocalDs;
  PlaceBloc(this.placeLocalDs) : super(PlaceInitialState()) {
    on<PlaceEvent>((event, emit) async {
      try {
        if (event is SetPlace) {
          emit(PlaceLoadingState());
          await placeLocalDs.setPLace(event.placeModel);
          List<PlaceModel> places = await placeLocalDs.getAllPlaces();
          print(places);
          emit(PlaceLoadedState(places: places));
        }
        if (event is GetAllPlaces) {
          emit(PlaceLoadingState());
          List<PlaceModel> places = await placeLocalDs.getAllPlaces();
          emit(PlaceLoadedState(places: places));
        }
        if (event is DeletePlace) {
          emit(PlaceLoadingState());
          await placeLocalDs.deletePlace(event.placeModel.id);
          List<PlaceModel> places = await placeLocalDs.getAllPlaces();
          emit(PlaceLoadedState(places: places));
        }
        if (event is UpdatePlace) {
          emit(PlaceLoadingState());
          await placeLocalDs.updatePlace(event.placeModel);
          List<PlaceModel> places = await placeLocalDs.getAllPlaces();
          emit(PlaceLoadedState(places: places));
        }
      } catch (e) {
        emit(PlaceErrorState(error: 'failed'));
        print(e);
      }
    });
  }
}