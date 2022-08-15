// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:me_medical_app/l10n/app_localization.dart';
import 'package:me_medical_app/services/auth.dart';

class Register extends StatefulWidget {
  final Function toggleView;
  Register({required this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  String error = '';

  //text field state
  String name = '';
  String phone = '';
  String email = '';
  String password = '';
  String confirmpassword = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: ListView(
                shrinkWrap: true,
                padding: EdgeInsets.only(left: 24.0, right: 24.0),
                children: <Widget>[
          Container(
            padding: EdgeInsets.only(
                left: 30.0, right: 20.0, top: 20.0, bottom: 20.0),
            child: Form(
                key: _formKey,
                child: Column(children: [
                  Text(
                    AppLocalization.of(context)
                        .getTranslatedValue("register")
                        .toString(),
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 25.0,
                  ),
                  TextFormField(
                    validator: (String? val) {
                      if (val != null && val.isEmpty) {
                        return AppLocalization.of(context)
                            .getTranslatedValue("nameField")
                            .toString();
                      }
                      return null;
                    },
                    onChanged: (val) {
                      setState(() => name = val);
                    },
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      prefixIcon: Icon(Icons.person),
                      hintText: AppLocalization.of(context)
                          .getTranslatedValue("fullName")
                          .toString(),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      labelStyle: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[200]),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: BorderSide(
                          color: Colors.blue,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: BorderSide(
                          color: Colors.indigo,
                          width: 2.0,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  TextFormField(
                    validator: (String? val) {
                      if (val != null && val.isEmpty) {
                        return AppLocalization.of(context)
                            .getTranslatedValue("phoneField")
                            .toString();
                      }
                      return null;
                    },
                    onChanged: (val) {
                      setState(() => phone = val);
                    },
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      prefixIcon: Icon(Icons.phone),
                      hintText: AppLocalization.of(context)
                          .getTranslatedValue("phoneNum")
                          .toString(),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      labelStyle: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[200]),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: BorderSide(
                          color: Colors.blue,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: BorderSide(
                          color: Colors.indigo,
                          width: 2.0,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
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
                      setState(() => email = val.trim());
                    },
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      prefixIcon: Icon(Icons.email),
                      hintText: AppLocalization.of(context)
                          .getTranslatedValue("email")
                          .toString(),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      labelStyle: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[200]),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: BorderSide(
                          color: Colors.blue,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: BorderSide(
                          color: Colors.indigo,
                          width: 2.0,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  TextFormField(
                    obscureText: true,
                    validator: (String? val) {
                      if (val != null && val.length < 6) {
                        return AppLocalization.of(context)
                            .getTranslatedValue("passError")
                            .toString();
                      }
                      return null;
                    },
                    onChanged: (val) {
                      setState(() => password = val);
                    },
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      prefixIcon: Icon(Icons.password),
                      hintText: AppLocalization.of(context)
                          .getTranslatedValue("password")
                          .toString(),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      labelStyle: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[200]),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: BorderSide(
                          color: Colors.blue,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: BorderSide(
                          color: Colors.indigo,
                          width: 2.0,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  TextFormField(
                    obscureText: true,
                    validator: (val) => (val == password) == false
                        ? AppLocalization.of(context)
                            .getTranslatedValue("confirmPassError")
                            .toString()
                        : null,
                    onChanged: (val) {
                      setState(() => confirmpassword = val);
                    },
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      prefixIcon: Icon(Icons.password),
                      hintText: AppLocalization.of(context)
                          .getTranslatedValue("confirmPassword")
                          .toString(),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      labelStyle: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[200]),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: BorderSide(
                          color: Colors.blue,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: BorderSide(
                          color: Colors.indigo,
                          width: 2.0,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Center(
                      child: ElevatedButton(
                          child: Text("Register"),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              dynamic result = await _auth.register(
                                  name, phone, email, password);
                              if (result == null) {
                                setState(() =>
                                    error = 'Please supply a valid email');
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              primary: Colors.indigo))),
                  SizedBox(height: 10.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Already have an account?"),
                      SizedBox(width: 20.0),
                      TextButton(
                        onPressed: () {
                          widget.toggleView();
                        },
                        child: Text(
                          AppLocalization.of(context)
                              .getTranslatedValue("login")
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
                ])),
          )
        ])));
  }
}
