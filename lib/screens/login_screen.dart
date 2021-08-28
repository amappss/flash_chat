import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/constants.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/widgets/rounded_button.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import 'chat_screen.dart';

class LoginScreen extends StatefulWidget {
  static const id = '/login';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  String email = '';
  String password = '';

  bool isProgressing = false;

  var fireBaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: isProgressing,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Flexible(
                  child: Hero(
                    tag: 'logo',
                    child: Container(
                      height: 200.0,
                      child: Image.asset('images/logo.png'),
                    ),
                  ),
                ),
                SizedBox(
                  height: 48.0,
                ),
                TextFormField(
                    validator: (value) {
                      return value.contains('@') ? null : 'email is not valid';
                    },
                    onChanged: (value) {
                      //Do something with the user input.
                      email = value;
                    },
                    decoration: kInputFieldDecoration.copyWith(
                        hintText: 'Entor your email')),
                SizedBox(
                  height: 8.0,
                ),
                TextFormField(
                    validator: (value) {
                      return value.length > 5
                          ? null
                          : 'password should be at least 6 letters';
                    },
                    obscureText: true,
                    onChanged: (value) {
                      //Do something with the user input.
                      password = value;
                    },
                    decoration: kInputFieldDecoration.copyWith(
                        hintText: 'Entor your password')),
                SizedBox(
                  height: 24.0,
                ),
                Rounded_button(
                  text: 'Log In',
                  backgroundColor: Colors.lightBlueAccent,
                  press: () async {
                    if (_formKey.currentState.validate()) {
                      setState(() {
                        isProgressing = true;
                      });
                      try {
                        var user =
                            await fireBaseAuth.signInWithEmailAndPassword(
                                email: email, password: password);
                        if (user != null) {
                          Navigator.pushNamed(context, ChatScreen.id);
                        }
                        setState(() {
                          isProgressing = false;
                        });
                      } on Exception catch (e) {
                        print(e);
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
