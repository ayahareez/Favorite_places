part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent {}

class SignIn extends AuthEvent {
  final AuthModel userModel;
  SignIn({required this.userModel});
}

class SignUp extends AuthEvent {
  final AuthModel userModel;
  SignUp({required this.userModel});
}

class SignOut extends AuthEvent {}

class CheckIfAuth extends AuthEvent {}