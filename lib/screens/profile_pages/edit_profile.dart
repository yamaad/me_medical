import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:me_medical_app/l10n/app_localization.dart';
import 'package:me_medical_app/services/auth.dart';

class EditProfile extends StatefulWidget {
  @override
  EditProfileState createState() => EditProfileState();
}

class EditProfileState extends State<EditProfile> {
  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
      .collection('users')
      .where('User ID', isEqualTo: AuthService().getCurrentUID())
      .snapshots();
  final AuthService _auth = AuthService();
  String name = '';
  String phone = '';
  String location = '';
  int status = 0;
  String password = '';
  String newpassword = '';
  String confirmnewpassword = '';
  String error = '';

  final _formKey = GlobalKey<FormState>();
  // Create a text controller. Later, use it to retrieve the
  // current value of the TextField.

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    // Start listening to changes.
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              centerTitle: true,
              title: Text(AppLocalization.of(context)
                  .getTranslatedValue("editProfile")
                  .toString()),
              backgroundColor: Colors.indigo,
              elevation: 3,
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            body: StreamBuilder<QuerySnapshot>(
                stream: _usersStream,
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Something went wrong');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: Text("Loading"));
                  } else {
                    return Column(
                      children: <Widget>[
                        // construct the profile details widget here
                        const SizedBox(
                          height: 10,
                        ),

                        // create widgets for each tab bar here
                        Center(
                            child: ListView(
                          padding: EdgeInsets.all(20.0),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          children: snapshot.data!.docs
                              .map((DocumentSnapshot document) {
                            Map<String, dynamic> data =
                                document.data()! as Map<String, dynamic>;

                            name = data['Name'];

                            phone = data['Phone'];
                            location = data['Clinic Location'];

                            return Form(
                                key: _formKey,
                                child: Column(children: <Widget>[
                                  const SizedBox(
                                    height: 15.0,
                                  ),
                                  TextFormField(
                                    initialValue: name,
                                    onChanged: (val) => name = val,
                                    validator: (String? val) {
                                      if (val != null && val.isEmpty) {
                                        return AppLocalization.of(context)
                                            .getTranslatedValue("nameField")
                                            .toString();
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      prefixIcon: const Icon(Icons.person),
                                      fillColor: Colors.white,
                                      filled: true,
                                      hintText: AppLocalization.of(context)
                                          .getTranslatedValue("fullName")
                                          .toString(),
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.always,
                                      labelStyle: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blue[200]),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(25.0),
                                        borderSide: const BorderSide(
                                          color: Colors.blue,
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(25.0),
                                        borderSide: const BorderSide(
                                          color: Colors.indigo,
                                          width: 2.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
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
                                    onChanged: (val) => phone = val,
                                    initialValue: data['Phone'],
                                    decoration: InputDecoration(
                                      prefixIcon: const Icon(Icons.phone),
                                      fillColor: Colors.white,
                                      filled: true,
                                      hintText: AppLocalization.of(context)
                                          .getTranslatedValue("phoneNum")
                                          .toString(),
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.always,
                                      labelStyle: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blue[200]),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(25.0),
                                        borderSide: const BorderSide(
                                          color: Colors.blue,
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(25.0),
                                        borderSide: const BorderSide(
                                          color: Colors.indigo,
                                          width: 2.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 15.0,
                                  ),
                                  TextFormField(
                                    onChanged: (val) => location = val,
                                    initialValue: data['Clinic Location'],
                                    decoration: InputDecoration(
                                      prefixIcon:
                                          Icon(CupertinoIcons.building_2_fill),
                                      fillColor: Colors.white,
                                      filled: true,
                                      hintText: AppLocalization.of(context)
                                          .getTranslatedValue("clinicLocation")
                                          .toString(),
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.always,
                                      labelStyle: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blue[200]),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(25.0),
                                        borderSide: const BorderSide(
                                          color: Colors.blue,
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(25.0),
                                        borderSide: const BorderSide(
                                          color: Colors.indigo,
                                          width: 2.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 15.0,
                                  ),
                                  Center(
                                      child: ElevatedButton(
                                          child: Text(
                                              AppLocalization.of(context)
                                                  .getTranslatedValue(
                                                      "changeInformation")
                                                  .toString()),
                                          onPressed: () async {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              setState(() => error =
                                                  'Changed successfully');
                                              await _auth.editProfile(
                                                  name, phone, location);

                                              Navigator.pop(context);
                                            }
                                          },
                                          style: ElevatedButton.styleFrom(
                                              primary: Colors.indigo))),
                                ]));
                          }).toList(),
                        )),
                      ],
                    );
                  }
                })));
  }
}
