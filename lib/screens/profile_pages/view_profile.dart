// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:me_medical_app/l10n/app_localization.dart';
import 'package:me_medical_app/l10n/app_localization_provider.dart';
import 'package:me_medical_app/models/icon.widget.dart';
import 'package:me_medical_app/screens/profile_pages/edit_profile.dart';
import 'package:me_medical_app/services/auth.dart';
import 'package:me_medical_app/services/wrapper.dart';
import 'package:me_medical_app/util/user_preferences.dart';
import 'package:provider/provider.dart';

// ignore: use_key_in_widget_constructors
class ViewProfilePage extends StatefulWidget {
  @override
  _ViewProfilePageState createState() => _ViewProfilePageState();
}

class _ViewProfilePageState extends State<ViewProfilePage> {
  static const keyLanguage = 'key-language';
  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
      .collection('users')
      .where('User ID', isEqualTo: AuthService().getCurrentUID())
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(AppLocalization.of(context)
              .getTranslatedValue("personInfo")
              .toString()),
          elevation: 3,
          actions: [
            IconButton(
              icon: Icon(
                Icons.edit,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => EditProfile()));
              },
            ),
          ],
        ),
        body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: const [
            Color(0XFF93a5cf),
            Color(0XFFe4efe9),
          ])),
          child: StreamBuilder<QuerySnapshot>(
            stream: _usersStream,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text('Something went wrong');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else {
                return SafeArea(
                    child: ListView(
                  children:
                      snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data =
                        document.data()! as Map<String, dynamic>;

                    return Stack(
                        clipBehavior: Clip.none,
                        alignment: Alignment.center,
                        children: [
                          Container(
                              padding:
                                  EdgeInsets.fromLTRB(30.0, 20.0, 0.0, 10.0),
                              decoration: BoxDecoration(
                                color: Colors.indigo[800],
                              ),
                              child: Container(
                                  margin: const EdgeInsets.all(15.0),
                                  padding: const EdgeInsets.all(3.0),
                                  child: Column(children: [
                                    buildUserInfo(
                                        AppLocalization.of(context)
                                            .getTranslatedValue("fullName")
                                            .toString(),
                                        data['Name']),
                                    SizedBox(
                                      height: 15.0,
                                    ),
                                    buildUserInfo(
                                        AppLocalization.of(context)
                                            .getTranslatedValue("email")
                                            .toString(),
                                        data['Email']),
                                    SizedBox(
                                      height: 15.0,
                                    ),
                                    buildUserInfo(
                                        AppLocalization.of(context)
                                            .getTranslatedValue("phoneNum")
                                            .toString(),
                                        data['Phone']),
                                    SizedBox(
                                      height: 15.0,
                                    ),
                                    buildUserInfo(
                                        AppLocalization.of(context)
                                            .getTranslatedValue(
                                                "clinicLocation")
                                            .toString(),
                                        data['Clinic Location']),
                                    SizedBox(
                                      height: 140.0,
                                    ),
                                  ]))),
                          SizedBox(
                            height: 15.0,
                          ),
                          Positioned(
                              top: MediaQuery.of(context).size.height * .25,
                              left: 15,
                              right: 15,
                              child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  child: ListView(
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    padding: EdgeInsets.all(12),
                                    children: [
                                      SettingsGroup(
                                          title: AppLocalization.of(context)
                                              .getTranslatedValue("general")
                                              .toString(),
                                          children: <Widget>[
                                            buildLanguage(),
                                            buildLogout(),
                                          ]),
                                      SizedBox(
                                        height: 25.0,
                                      ),
                                    ],
                                  )))
                        ]);
                  }).toList(),
                ));
              }
            },
          ),
        ));
  }

  Widget buildLanguage() => DropDownSettingsTile(
        title: AppLocalization.of(context)
            .getTranslatedValue("language")
            .toString(),
        settingKey: keyLanguage,
        selected: 1,
        values: <int, String>{
          1: AppLocalization.of(context)
              .getTranslatedValue("English")
              .toString(),
          2: AppLocalization.of(context)
              .getTranslatedValue("Mandarin")
              .toString(),
        },
        onChange: (language) {
          if (language == 1) {
            _changeLanguage('en', context);
          } else {
            _changeLanguage('zh', context);
          }
        },
      );

  Widget buildLogout() => SimpleSettingsTile(
        title:
            AppLocalization.of(context).getTranslatedValue("logout").toString(),
        subtitle: '',
        leading: IconWidget(
          icon: Icons.logout,
          color: Colors.blueAccent,
        ),
        onTap: () async {
          await FirebaseAuth.instance.signOut().then((value) =>
              // ignore: unnecessary_this
              Navigator.of(this.context, rootNavigator: true)
                  .pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return Wrapper();
                  },
                ),
                (_) => false,
              ));
        },
      );

  Widget buildUserInfo(String header, String content) => Row(
        children: [
          Text(
            header,
            style: TextStyle(
                fontSize: 18.0,
                color: Colors.white,
                fontWeight: FontWeight.bold),
          ),
          Text(
            " : " + content,
            style: TextStyle(fontSize: 16.0, color: Colors.white),
          ),
        ],
      );

  void _changeLanguage(String languageCode, context) async {
    Locale _selectedLocale = await UserPreferences().setLocale(languageCode);

    final appLocaleProvider =
        Provider.of<LocaleNotifier>(context, listen: false);

    appLocaleProvider.setLocale(_selectedLocale);
  }
}
