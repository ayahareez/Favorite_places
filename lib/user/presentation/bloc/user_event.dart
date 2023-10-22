part of 'user_bloc.dart';

@immutable
abstract class UserEvent {}

class SetUserData extends UserEvent {
  final UserModel userModel;

  SetUserData({required this.userModel});
}

class HasSignedUp extends UserEvent {}

class LogOut extends UserEvent {}