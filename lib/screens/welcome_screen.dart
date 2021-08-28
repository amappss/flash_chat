import 'package:flutter/material.dart';
import 'package:flash_chat/widgets/rounded_button.dart';
import 'login_screen.dart';
import 'registration_screen.dart';
import 'registration_screen.dart';

class WelcomeScreen extends StatefulWidget {
  static const id = '/';
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation animation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = AnimationController(
        duration: Duration(seconds: 1), vsync: this, upperBound: 1);
    animation = ColorTween(begin: Colors.lightBlue, end: Colors.white)
        .animate(controller);
    controller.forward();
    controller.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: animation.value,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(
                  tag: 'logo',
                  child: Container(
                      child: Image.asset('images/logo.png'), height: 60),
                ),
                Text(
                  'Flash Chat',
                  style: TextStyle(
                    fontSize: 42.0,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            Rounded_button(
              text: 'Log In',
              backgroundColor: Colors.lightBlueAccent,
              press: () {
                Navigator.pushNamed(context, LoginScreen.id);
              },
            ),
            Rounded_button(
              text: 'Register',
              backgroundColor: Colors.blueAccent,
              press: () {
                Navigator.pushNamed(context, RegistrationScreen.id);
              },
            ),
          ],
        ),
      ),
    );
  }
}
