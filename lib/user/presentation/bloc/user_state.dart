part of 'user_bloc.dart';

@immutable
abstract class UserState {}

class UserUnauthorized extends UserState {}

class UserLoadingState extends UserState {} //طالما في Future

class UserAuthorizedState extends UserState {}

class UserErrorState extends UserState {
  final String error;

  UserErrorState({required this.error});
}