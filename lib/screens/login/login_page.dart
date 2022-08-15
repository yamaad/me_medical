// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:me_medical_app/l10n/app_localization.dart';
import 'package:me_medical_app/services/auth.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;
  const SignIn({required this.toggleView});
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  //text field state
  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
            child: ListView(
                shrinkWrap: true,
                padding: EdgeInsets.only(left: 24.0, right: 24.0),
                children: <Widget>[
              Logo(),
              SizedBox(
                height: 20.0,
              ),
              LogoWord(),
              SizedBox(
                height: 20.0,
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 20.0),
                    TextFormField(
                      validator: (String? val) {
                        if (val != null && val.isEmpty) {
                          return AppLocalization.of(context)
                              .getTranslatedValue("emailField")
                              .toString();
                        }
                        return null;
                      },
                      onChanged: (val) {
                        setState(() => email = val);
                      },
                      decoration: InputDecoration(
                          hintText: AppLocalization.of(context)
                              .getTranslatedValue("email")
                              .toString(),
                          contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32),
                            gapPadding: 5,
                          )),
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      validator: (String? val) {
                        if (val != null && val.isEmpty) {
                          return AppLocalization.of(context)
                              .getTranslatedValue("passwordField")
                              .toString();
                        }
                        return null;
                      },
                      obscureText: true,
                      onChanged: (val) {
                        setState(() => password = val);
                      },
                      decoration: InputDecoration(
                          hintText: AppLocalization.of(context)
                              .getTranslatedValue("password")
                              .toString(),
                          contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32),
                            gapPadding: 5,
                          )),
                    ),
                    SizedBox(height: 30.0),
                    ElevatedButton(
                        child: Text(
                            AppLocalization.of(context)
                                .getTranslatedValue("login")
                                .toString(),
                            style: TextStyle(color: Colors.white)),
                        style: ElevatedButton.styleFrom(primary: Colors.indigo),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            dynamic result = await _auth.logIn(email, password);
                            if (result == null) {
                              setState(() => error = 'Wrong credentials');
                            }
                          }
                        }),
                    SizedBox(height: 10.0),
                    Text(error, style: TextStyle(color: Colors.red)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Don't have an account?"),
                        SizedBox(width: 20.0),
                        TextButton(
                          onPressed: () {
                            widget.toggleView();
                          },
                          child: Text(
                            AppLocalization.of(context)
                                .getTranslatedValue("register")
                                .toString(),
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.right,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ])));
  }
}

//logo picture
class Logo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: CircleAvatar(
      radius: 64,
      backgroundImage: AssetImage('assets/images/icon1.png'),
      backgroundColor: Colors.transparent,
    ));
  }
}

//logo word
class LogoWord extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Text(
      "Easy Clinic",
      style: TextStyle(
        color: Colors.black87,
        fontSize: 36,
        fontWeight: FontWeight.bold,
      ),
    ));
  }
}

//class logbutton
class LogButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final loginButton = Padding(
        padding: EdgeInsets.symmetric(vertical: 1.0),
        child: Material(
          borderRadius: BorderRadius.circular(20),
          child: MaterialButton(
              minWidth: 80.0,
              height: 40.0,
              //later implement the jump page function
              onPressed: () {},
              color: Colors.lightBlueAccent,
              child: Text(
                'Log in',
                style: TextStyle(fontSize: 30),
              )),
        ));
    return loginButton;
  }
}
