import 'package:flutter/material.dart';
import 'package:me_medical_app/screens/login/login_page.dart';
import 'package:me_medical_app/screens/login/register.dart';

// ignore: use_key_in_widget_constructors
class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool showSignIn = true;

  void toggleView() {
    setState(() => showSignIn = !showSignIn);
  }

  @override
  Widget build(BuildContext context) {
    if (showSignIn) {
      return SignIn(toggleView: toggleView);
    } else {
      return Register(toggleView: toggleView);
    }
  }
}
