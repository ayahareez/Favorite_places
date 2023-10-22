import 'package:favorite_places/places/presentation/pages/fav_places_page.dart';
import 'package:favorite_places/user/data/models/user_model.dart';
import 'package:favorite_places/user/presentation/bloc/user_bloc.dart';
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
        title: Text(
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
                  Text(
                    'welcome',
                    style: TextStyle(
                      fontSize: 40.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 32,
                  ),
                  TextFormField(
                    controller: name,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
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
                  SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    controller: email,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
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
                  SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    controller: password,
                    keyboardType: TextInputType.emailAddress,
                    obscureText: true,
                    decoration: InputDecoration(
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
                  SizedBox(
                    height: 32,
                  ),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color(0xfffb6f92),
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        if (formkey.currentState!.validate()) {
                          UserModel userModel = UserModel(
                              password: password.text,
                              email: email.text,
                              name: name.text);
                          context
                              .read<UserBloc>()
                              .add(SetUserData(userModel: userModel));

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => FavoritePlacesPage()));
                        }
                      },
                      child: Text(
                        'Sign Up',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontFamily: 'UbuntuCondensed-Regular',
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xfffb6f92)),
                    ),
                  ),
                  SizedBox(
                    height: 32,
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