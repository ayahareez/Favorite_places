import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:favorite_places/user/data/data_source/sign_up_remote_ds.dart';
import 'package:favorite_places/user/data/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:meta/meta.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthinticationRemoteDs authinticationRemoteDs;

  AuthBloc(this.authinticationRemoteDs) : super(UserUnauthorized()) {
    on<AuthEvent>((event, emit) async {
      try {
        if (event is SignUp) {
          emit(UserLoadingState());
          await authinticationRemoteDs.signUp(event.userModel);
          emit(UserAuthorizedState());
        } else if (event is SignIn) {
          emit(UserLoadingState());
          await authinticationRemoteDs.signIn(event.userModel);
          if (authinticationRemoteDs.checkIfAuth()) {
            emit(UserAuthorizedState());
          } else {
            emit(UserUnauthorized());
          }
        } else if (event is CheckIfAuth) {
          emit(UserLoadingState());
          final isSigned = authinticationRemoteDs.checkIfAuth();
          // print(isSigned);
          if (isSigned) {
            emit(UserAuthorizedState());
          } else {
            emit(UserUnauthorized());
          }
        } else if (event is SignOut) {
          emit(UserLoadingState());
          await authinticationRemoteDs.signOut();
          emit(UserUnauthorized());
        }
      } catch (e) {
        // Handle the exception here
        emit(UserErrorState(
            error: 'please enter your Credentials correctly,or sign up '));
      }
    });
  }
}