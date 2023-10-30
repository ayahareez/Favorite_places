import 'package:easy_localization/easy_localization.dart';
import 'package:favorite_places/places/presentation/pages/fav_places_page.dart';
import 'package:favorite_places/user/data/models/user_model.dart';
import 'package:favorite_places/user/presentation/pages/signup_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../bloc/auth_bloc.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    context.read<AuthBloc>().add(CheckIfAuth());
    super.initState();
  }

  var email = TextEditingController();

  var password = TextEditingController();

  var formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        builder: (context, state) {
          print(state);
          if (state is UserLoadingState) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is UserErrorState) {
            showToast("An error occurred: ${state.error}");
          }
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Center(
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 40.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'UbuntuCondensed-Regular',
                        ),
                      ),
                      const SizedBox(
                        height: 40.0,
                      ),
                      TextFormField(
                        controller: email,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          labelStyle: TextStyle(color: Color(0xfffb6f92)),
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(
                            Icons.email,
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Eamil must be entered';
                          }
                        },
                      ),
                      const SizedBox(
                        height: 15.0,
                      ),
                      TextFormField(
                        controller: password,
                        keyboardType: TextInputType.emailAddress,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Password',
                          labelStyle: TextStyle(color: Color(0xfffb6f92)),
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(
                            Icons.lock,
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Password must be entered';
                          }
                        },
                      ),
                      const SizedBox(
                        height: 35.0,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            AuthModel userModel = AuthModel(
                                password: password.text, email: email.text);
                            context
                                .read<AuthBloc>()
                                .add(SignIn(userModel: userModel));
                          }
                        },
                        child: Text(
                          tr('login'),
                          style: const TextStyle(
                              color: Colors.white, fontSize: 18),
                        ),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xfffb6f92)),
                      ),
                      const SizedBox(
                        height: 35.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Don\'t have an account ? ',
                            style: TextStyle(fontSize: 18),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => SignUpPage()));
                            },
                            child: const Text('Register now',
                                style: TextStyle(
                                    fontSize: 20, color: Color(0xfffb6f92))),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
        listener: (BuildContext context, AuthState state) {
          if (state is UserAuthorizedState) {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const FavoritePlacesPage()));
          }
        },
      ),
    );
  }
}

void showToast(String message) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.CENTER,
    timeInSecForIosWeb: 1,
    backgroundColor: Colors.red,
    textColor: Colors.white,
    fontSize: 16.0,
  );
}