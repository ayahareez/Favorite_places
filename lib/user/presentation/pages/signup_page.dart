import 'package:favorite_places/places/presentation/pages/fav_places_page.dart';
import 'package:favorite_places/user/data/models/user_model.dart';
import 'package:favorite_places/user/presentation/bloc/user_bloc.dart';
import 'package:favorite_places/user/presentation/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpPage extends StatelessWidget {
  var email = TextEditingController();
  var name = TextEditingController();
  var password = TextEditingController();
  GlobalKey<FormState> formkey = GlobalKey();

  SignUpPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Sign Up',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: formkey,
              child: Column(
                children: [
                  const Text(
                    'welcome',
                    style: TextStyle(
                      fontSize: 40.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  TextFormField(
                    controller: name,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Name',
                      labelStyle: TextStyle(color: Color(0xfffb6f92)),
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(
                        Icons.person,
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Name must be entered';
                      }
                    },
                  ),
                  const SizedBox(
                    height: 16,
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
                        return 'Email must be entered';
                      }
                    },
                  ),
                  const SizedBox(
                    height: 16,
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
                    height: 32,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (formkey.currentState!.validate()) {
                        UserModel userModel = UserModel(
                          password: password.text,
                          email: email.text,
                        );
                        context
                            .read<UserBloc>()
                            .add(SignUp(userModel: userModel));

                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const FavoritePlacesPage()));
                      }
                    },
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontFamily: 'UbuntuCondensed-Regular',
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xfffb6f92),
                    ),
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => LoginPage()));
                    },
                    child: const Text('login',
                        style:
                            TextStyle(fontSize: 24, color: Color(0xfffb6f92))),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}