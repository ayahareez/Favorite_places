part of 'place_bloc.dart';

@immutable
abstract class PlaceState {}

class PlaceInitial extends PlaceState {}

class PlaceLoading extends PlaceState {}

class PlaceLoaded extends PlaceState {
  final List<PlaceModel> places;
  PlaceLoaded({required this.places});
}