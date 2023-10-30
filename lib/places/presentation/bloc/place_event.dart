part of 'place_bloc.dart';

@immutable
abstract class PlaceEvent {}

class SetPlace extends PlaceEvent {
  final PlaceModel placeModel;
  SetPlace({required this.placeModel});
}

class GetAllPlaces extends PlaceEvent {}

class DeletePlace extends PlaceEvent {
  PlaceModel placeModel;
  DeletePlace({required this.placeModel});
}

class UpdatePlace extends PlaceEvent {
  PlaceModel placeModel;
  UpdatePlace({required this.placeModel});
}