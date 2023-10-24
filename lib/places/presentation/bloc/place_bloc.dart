import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:favorite_places/places/data/data_source/place_local_ds.dart';
import 'package:favorite_places/places/data/models/place_model.dart';
import 'package:meta/meta.dart';

part 'place_event.dart';
part 'place_state.dart';

class PlaceBloc extends Bloc<PlaceEvent, PlaceState> {
  PlaceLocalDs placeLocalDs;
  PlaceBloc(this.placeLocalDs) : super(PlaceInitial()) {
    on<PlaceEvent>((event, emit) async {
      try {
        if (event is SetPlace) {
          emit(PlaceLoading());
          await placeLocalDs.setPLace(event.placeModel);
          List<PlaceModel> places = await PlaceLocalDsImpl().getPlaces();
          emit(PlaceLoaded(places: places));
        }
      } catch (e) {
        emit(PlaceError(error: 'failed'));
      }
      if (event is GetPlace) {
        emit(PlaceLoading());
        List<PlaceModel> places = await placeLocalDs.getPlaces();
        emit(PlaceLoaded(places: places));
      }
    });
  }
}