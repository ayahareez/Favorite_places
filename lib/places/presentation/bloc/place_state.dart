part of 'place_bloc.dart';

@immutable
abstract class PlaceState {}

class PlaceInitialState extends PlaceState {}

class PlaceLoadingState extends PlaceState {}

class PlaceLoadedState extends PlaceState {
  final List<PlaceModel> places;
  PlaceLoadedState({required this.places});
}

class PlaceErrorState extends PlaceState {
  final String error;

  PlaceErrorState({required this.error});
}