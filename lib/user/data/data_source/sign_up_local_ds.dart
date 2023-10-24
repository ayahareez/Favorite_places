import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_model.dart';

// abstract class UserLocalDs {
//   Future<void> setUser(UserModel userModel);
//   Future<UserModel> getUser();
//   Future<bool> hasSignedUp();
//   Future<void> logOut();
// }
//
// class UserLocalDsImpl extends UserLocalDs {
//   String userKey = 'SignedUp user';
//
//   @override
//   Future<UserModel> getUser() async {
//     final pref = await SharedPreferences.getInstance();
//     final String? result = pref.getString(userKey);
//     late UserModel userModel;
//     if (result != null) {
//       final Map<String, dynamic> user = jsonDecode(result);
//       userModel = UserModel.fromMap(user);
//     } else {
//       throw Exception('not found');
//     }
//     return userModel;
//   }
//
//   @override
//   Future<void> setUser(UserModel userModel) async {
//     final pref = await SharedPreferences.getInstance();
//     final String user = jsonEncode(userModel.toMap());
//     await pref.setString('SignedUp user', user);
//   }
//
//   @override
//   Future<void> logOut() async {
//     final pref = await SharedPreferences.getInstance();
//     pref.remove('SignedUp user');
//   }
//
//   @override
//   Future<bool> hasSignedUp() async {
//     final pref = await SharedPreferences.getInstance();
//     String? result = pref.getString(userKey);
//     return result != null;
//   }
// }

abstract class AuthinticationRemoteDs {
  Future<void> signIn(UserModel userModel);
  Future<void> signUp(UserModel userModel);
  Future<void> signOut();
  bool checkIfAuth();
}

class AuthinticationRemoteDsImpl extends AuthinticationRemoteDs {
  @override
  Future<void> signIn(UserModel userModel) async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: userModel.email, password: userModel.password);
  }

  @override
  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Future<void> signUp(UserModel userModel) async {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: userModel.email,
      password: userModel.password,
    );
  }

  @override
  bool checkIfAuth() => FirebaseAuth.instance.currentUser != null;
}