import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_model.dart';

abstract class AuthinticationRemoteDs {
  Future<void> signIn(AuthModel userModel);
  Future<void> signUp(AuthModel userModel);
  Future<void> signOut();
  bool checkIfAuth();
  String getUserId();
}

class AuthinticationRemoteDsImpl extends AuthinticationRemoteDs {
  @override
  Future<void> signIn(AuthModel userModel) async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: userModel.email, password: userModel.password);
  }

  @override
  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Future<void> signUp(AuthModel userModel) async {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: userModel.email,
      password: userModel.password,
    );
  }

  @override
  bool checkIfAuth() => FirebaseAuth.instance.currentUser != null;

  @override
  String getUserId() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return user.uid;
    }
    return throw Exception('the user did\'t sign in');
  }
}