// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:me_medical_app/l10n/app_localization.dart';
import 'package:me_medical_app/services/wrapper.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class Dashboard extends StatefulWidget {
  final PersistentTabController persistentTabController;

  Dashboard({required this.persistentTabController});

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          bottomOpacity: 0.0,
          elevation: 0.0,
          leading: IconButton(
            icon: Icon(
              Icons.person,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                widget.persistentTabController.jumpToTab(4);
              });
            },
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: () async {
                await FirebaseAuth.instance.signOut().then((value) =>
                    Navigator.of(context, rootNavigator: true)
                        .pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (BuildContext context) {
                          return Wrapper();
                        },
                      ),
                      (_) => false,
                    ));
              },
            ),
          ],
        ),
        body: Container(
            decoration: BoxDecoration(color: Colors.indigo),
            child: Column(children: [
              Container(
                padding: EdgeInsets.all(30.0),
                height: 300.0,
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      AppLocalization.of(context)
                          .getTranslatedValue("dashboard")
                          .toString(),
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    )),
              ),
              Expanded(
                  child: Container(
                      padding: EdgeInsets.all(30.0),
                      decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30))),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                    flex: 2,
                                    child: SizedBox(
                                        height: 150,
                                        width: 150,
                                        child: TextButton(
                                            style: TextButton.styleFrom(
                                              primary: Colors.black,
                                              backgroundColor: Colors.white,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                widget.persistentTabController
                                                    .jumpToTab(1);
                                              });
                                            }, // Handle your callback
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.personal_injury_sharp,
                                                  size: 50,
                                                ),
                                                SizedBox(
                                                  height: 15,
                                                ),
                                                Text(
                                                  AppLocalization.of(context)
                                                      .getTranslatedValue(
                                                          "patientcheck")
                                                      .toString(),
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontSize: 20.0,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )
                                              ],
                                            )))),
                                SizedBox(
                                  width: 30.0,
                                ),
                                Expanded(
                                    flex: 2,
                                    child: Container(
                                        height: 150,
                                        width: 150,
                                        child: TextButton(
                                            style: TextButton.styleFrom(
                                              primary: Colors.black,
                                              backgroundColor: Colors.white,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                widget.persistentTabController
                                                    .jumpToTab(2);
                                              });
                                            }, // Handle your callback
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.sick,
                                                  size: 50,
                                                ),
                                                SizedBox(
                                                  height: 15,
                                                ),
                                                Text(
                                                  AppLocalization.of(context)
                                                      .getTranslatedValue(
                                                          "patientInfo")
                                                      .toString(),
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontSize: 20.0,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )
                                              ],
                                            )))),
                              ],
                            ),
                            SizedBox(
                              width: 20.0,
                              height: 40.0,
                            ),
                            Expanded(
                                flex: 1,
                                child: SizedBox(
                                    height: 150,
                                    width: 150,
                                    child: TextButton(
                                        style: TextButton.styleFrom(
                                          primary: Colors.black,
                                          backgroundColor: Colors.white,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            widget.persistentTabController
                                                .jumpToTab(3);
                                          });
                                        }, // Handle your callback
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.medication,
                                              size: 50,
                                            ),
                                            SizedBox(
                                              height: 15,
                                            ),
                                            Text(
                                              AppLocalization.of(context)
                                                  .getTranslatedValue(
                                                      "medicalIn")
                                                  .toString(),
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: 20.0,
                                                  fontWeight: FontWeight.bold),
                                            )
                                          ],
                                        )))),
                          ])))
            ])));
  }
}
