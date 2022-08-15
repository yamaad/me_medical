// ignore_for_file: use_key_in_widget_constructors
import 'package:flutter/material.dart';
import 'package:me_medical_app/models/user.dart';
import 'package:provider/provider.dart';
import 'package:me_medical_app/models/bottom_nav_screen.dart';
import 'package:me_medical_app/services/authenticate.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<TheUser?>(context);
    // return either Home or Authenticate widget
    if (user == null) {
      return Authenticate();
    } else {
      return BottomNavScreen();
    }
  }
}
