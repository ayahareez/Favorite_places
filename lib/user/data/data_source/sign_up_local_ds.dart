import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_model.dart';

abstract class UserLocalDs {
  Future<void> setUser(UserModel userModel);
  Future<UserModel> getUser();
  Future<bool> hasSignedUp();
  Future<void> logOut();
}

class UserLocalDsImpl extends UserLocalDs {
  String userKey = 'SignedUp user';

  @override
  Future<UserModel> getUser() async {
    final pref = await SharedPreferences.getInstance();
    final String? result = pref.getString(userKey);
    late UserModel userModel;
    if (result != null) {
      final Map<String, dynamic> user = jsonDecode(result);
      userModel = UserModel.fromMap(user);
    } else {
      throw Exception('not found');
    }
    return userModel;
  }

  @override
  Future<void> setUser(UserModel userModel) async {
    final pref = await SharedPreferences.getInstance();
    final String user = jsonEncode(userModel.toMap());
    await pref.setString('SignedUp user', user);
  }

  @override
  Future<void> logOut() async {
    final pref = await SharedPreferences.getInstance();
    pref.remove('SignedUp user');
  }

  @override
  Future<bool> hasSignedUp() async {
    final pref = await SharedPreferences.getInstance();
    String? result = pref.getString(userKey);
    return result != null;
  }
}