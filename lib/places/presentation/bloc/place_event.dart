part of 'place_bloc.dart';

@immutable
abstract class PlaceEvent {}

class SetPlace extends PlaceEvent{
  final PlaceModel placeModel;
  SetPlace({required this.placeModel});

}

class GetPlace extends PlaceEvent{}