import 'package:flash_chat/constants.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/widgets/rounded_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class RegistrationScreen extends StatefulWidget {
  static const id = '/register';

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
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
                    validator: (String value) {
                      return value.contains('@')
                          ? null
                          : 'please enter valid email';
                    },
                    onChanged: (value) {
                      //Do something with the user input.
                      email = value;
                    },
                    decoration: InputDecoration(
                      hintText: 'Enter your email',
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 20.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(32.0)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.blueAccent, width: 1.0),
                        borderRadius: BorderRadius.all(Radius.circular(32.0)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.blueAccent, width: 2.0),
                        borderRadius: BorderRadius.all(Radius.circular(32.0)),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  TextFormField(
                      validator: (String value) {
                        return value.length > 5
                            ? null
                            : 'password must be at least 6 letters';
                      },
                      obscureText: true,
                      onChanged: (value) {
                        //Do something with the user input.
                        password = value;
                      },
                      decoration: kInputFieldDecoration.copyWith(
                          hintText: 'Enter your password')),
                  SizedBox(
                    height: 24.0,
                  ),
                  Rounded_button(
                    text: 'Register',
                    backgroundColor: Colors.blueAccent,
                    press: () async {
                      if (_formKey.currentState.validate()) {
                        setState(() {
                          isProgressing = true;
                        });
                        try {
                          var user =
                              await fireBaseAuth.createUserWithEmailAndPassword(
                                  email: email, password: password);
                          if (user != null) {
                            Navigator.pushNamed(context, ChatScreen.id);
                          }
                          setState(() {
                            isProgressing = false;
                          });
                        } catch (e) {
                          print(e);
                        } 
                      }
                      // Navigator.pushNamed(context, RegistrationScreen.id);
                    },
                  ),
                ]),
          ),
        ),
      ),
    );
  }
}
