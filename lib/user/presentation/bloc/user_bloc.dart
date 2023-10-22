import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:favorite_places/user/data/data_source/sign_up_local_ds.dart';
import 'package:favorite_places/user/data/models/user_model.dart';

import 'package:meta/meta.dart';

part 'user_event.dart';

part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(UserUnauthorized()) {
    on<UserEvent>((event, emit) async {
      if (event is SetUserData) {
        try {
          emit(UserLoadingState());
          await UserLocalDsImpl().setUser(event.userModel);
          UserModel userModel = await UserLocalDsImpl().getUser();
          emit(UserAuthorizedState(userModel: userModel));
        } catch (e) {
          // Handle the exception here
          emit(UserErrorState(error: 'Failed to set user data.'));
        }
      }
      if (event is HasSignedUp) {
        try {
          final isSigned = await UserLocalDsImpl().hasSignedUp();
          print(isSigned);
          if (isSigned) {
            final UserModel userModel = await UserLocalDsImpl().getUser();
            emit(UserAuthorizedState(userModel: userModel));
          } else {
            emit(UserUnauthorized());
          }
        } catch (e) {
          // Handle the exception here
          emit(UserErrorState(error: 'Failed to get user data.'));
        }
      }
      if (event is LogOut) {
        await UserLocalDsImpl().logOut();
        emit(UserUnauthorized());
      }
    });
  }
}