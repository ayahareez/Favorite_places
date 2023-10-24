part of 'user_bloc.dart';

@immutable
abstract class UserEvent {}

class SignIn extends UserEvent {
  final UserModel userModel;
  SignIn({required this.userModel});
}

class SignUp extends UserEvent {
  final UserModel userModel;
  SignUp({required this.userModel});
}

class SignOut extends UserEvent {}

class CheckIfAuth extends UserEvent {}