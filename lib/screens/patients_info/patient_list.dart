// ignore_for_file: prefer_const_constructors
import 'package:flutter/cupertino.dart';
import 'package:me_medical_app/l10n/app_localization.dart';
import 'package:me_medical_app/screens/patients_info/add_patient.dart';
import 'package:me_medical_app/screens/patients_info/patient_previous_visits.dart';
import 'package:me_medical_app/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:me_medical_app/services/database.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

// ignore: use_key_in_widget_constructors
class PatientListPage extends StatefulWidget {
  @override
  _PatientListPageState createState() => _PatientListPageState();
}

class _PatientListPageState extends State<PatientListPage> {
  TextEditingController editingController = TextEditingController();
  Future getPosts() async {
    var firestore = FirebaseFirestore.instance;

    QuerySnapshot qn = await firestore
        .collection("patients")
        .doc(AuthService().getCurrentUID())
        .collection('patientInfo')
        .get();

    return qn.docs;
  }

  final db = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: Text(AppLocalization.of(context)
              .getTranslatedValue("patientList")
              .toString()),
          elevation: 3,
        ),
        body: FutureBuilder(
            future: getPosts(),
            builder: (_, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return Column(
                  children: [
                    Container(
                        decoration: BoxDecoration(
                            color: Colors.indigo,
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10))),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: TextField(
                            autofocus: false,
                            onChanged: (value) {
                              setState(() {});
                            },
                            controller: editingController,
                            decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                hintText: AppLocalization.of(context)
                                    .getTranslatedValue("search")
                                    .toString(),
                                prefixIcon: Icon(Icons.search),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(25.0)))),
                          ),
                        )),
                    Expanded(
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, index) {
                              if (editingController.text.isEmpty) {
                                return Card(
                                    elevation: 5.0,
                                    margin: EdgeInsets.fromLTRB(10, 7, 10, 7),
                                    child: Align(
                                        alignment: Alignment.center,
                                        child: ListTile(
                                            title: Text(
                                                snapshot.data[index]
                                                    .data()["Patient Name"],
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            trailing: Wrap(
                                              children: [
                                                Text(
                                                    snapshot.data[index]
                                                        .data()["IC"],
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold))
                                              ],
                                            ),
                                            onTap: () {
                                              editingController.clear();
                                              pushNewScreen(
                                                context,
                                                screen: PatientDetailPage(
                                                    patientInfo:
                                                        snapshot.data[index]),
                                                withNavBar:
                                                    true, // OPTIONAL VALUE. True by default.
                                                pageTransitionAnimation:
                                                    PageTransitionAnimation
                                                        .cupertino,
                                              );
                                            })));
                              } else if (snapshot.data[index]["Patient Name"]
                                      .toLowerCase()
                                      .contains(editingController.text) ||
                                  snapshot.data[index]["IC"]
                                      .toLowerCase()
                                      .contains(editingController.text)) {
                                return SizedBox(
                                    height: 80.0,
                                    child: Card(
                                        margin: EdgeInsets.all(10),
                                        child: Align(
                                            alignment: Alignment.center,
                                            child: ListTile(
                                                title: Text(
                                                    snapshot.data[index]
                                                        .data()["Patient Name"],
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                trailing: Wrap(
                                                  children: [
                                                    Text(
                                                        snapshot.data[index]
                                                            .data()["IC"]
                                                            .toString(),
                                                        style: TextStyle(
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold))
                                                  ],
                                                ),
                                                onTap: () {
                                                  editingController.clear();
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              PatientDetailPage(
                                                                patientInfo:
                                                                    snapshot.data[
                                                                        index],
                                                              )));
                                                }))));
                              } else {
                                return Container();
                              }
                            }))
                  ],
                );
              }
            }),
        floatingActionButton: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              FloatingActionButton.extended(
                  heroTag: null,
                  elevation: 10.0,
                  label: Text(AppLocalization.of(context)
                      .getTranslatedValue("addP")
                      .toString()),
                  icon: Icon(Icons.add),
                  backgroundColor: Colors.blueAccent[800],
                  onPressed: () {
                    pushNewScreen(
                      context,
                      screen: AddPatientPage(),
                      withNavBar: true, // OPTIONAL VALUE. True by default.
                      pageTransitionAnimation:
                          PageTransitionAnimation.cupertino,
                    );
                  }),
            ]));
  }
}

class PatientDetailPage extends StatefulWidget {
  final DocumentSnapshot? patientInfo;

  PatientDetailPage({this.patientInfo});

  @override
  _PatientDetailPageState createState() => _PatientDetailPageState();
}

class _PatientDetailPageState extends State<PatientDetailPage> {
  final _formKey = GlobalKey<FormState>();
  String patientName = '';
  String ic = '';
  String gender = '';
  String contactNumber = '';
  String bod = '';
  String address = '';
  DateTime date = DateTime.now();

  @override
  Widget build(BuildContext context) {
    patientName = widget.patientInfo!['Patient Name'];
    ic = widget.patientInfo!['IC'].toString();
    bod = widget.patientInfo!['BOD'].toString();
    gender = widget.patientInfo!['Gender'].toString();
    contactNumber = widget.patientInfo!['ContactNumber'].toString();
    address = widget.patientInfo!['address'].toString();
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(widget.patientInfo!['Patient Name'],
              overflow: TextOverflow.ellipsis),
          backgroundColor: Colors.indigo,
          elevation: 3,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () async {
                showDialog(
                    useRootNavigator: false,
                    barrierDismissible: true,
                    context: context,
                    builder: (BuildContext context) {
                      return CupertinoAlertDialog(
                        title: Text(AppLocalization.of(context)
                                .getTranslatedValue("confirmDelete")
                                .toString() +
                            widget.patientInfo!['Patient Name'] +
                            "?"),
                        content: Text(AppLocalization.of(context)
                                .getTranslatedValue("allInformation")
                                .toString() +
                            widget.patientInfo!['Patient Name'] +
                            AppLocalization.of(context)
                                .getTranslatedValue("lost")
                                .toString()),
                        actions: [
                          TextButton(
                            child: Text(AppLocalization.of(context)
                                .getTranslatedValue("cancel")
                                .toString()),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          TextButton(
                            child: Text(AppLocalization.of(context)
                                .getTranslatedValue("confirm")
                                .toString()),
                            onPressed: () async {
                              await DatabaseService(
                                      uid: AuthService().getCurrentUID())
                                  .deletePatient(widget.patientInfo!['IC']);
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PatientListPage(),
                                ),
                              );
                            },
                          )
                        ],
                      );
                    });
              },
            )
          ],
        ),
        body: Container(
            padding: EdgeInsets.only(
                left: 30.0, right: 20.0, top: 20.0, bottom: 20.0),
            child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      readOnly: true,
                      initialValue: patientName,
                      onChanged: (val) {
                        setState(() => patientName = val);
                      },
                      validator: (String? val) {
                        if (val != null && val.isEmpty) {
                          return AppLocalization.of(context)
                              .getTranslatedValue("nameField")
                              .toString();
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        prefixIcon: Icon(Icons.person),
                        hintText: AppLocalization.of(context)
                            .getTranslatedValue("patientName")
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
                      readOnly: true,
                      initialValue: ic,
                      validator: (String? val) {
                        if (val != null && val.isEmpty) {
                          return AppLocalization.of(context)
                              .getTranslatedValue("idField")
                              .toString();
                        }
                        return null;
                      },
                      onChanged: (val) {
                        setState(() => ic = val);
                      },
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        prefixIcon: Icon(Icons.credit_card),
                        hintText: AppLocalization.of(context)
                            .getTranslatedValue("patientID")
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
                      readOnly: true,
                      initialValue: bod,
                      validator: (String? val) {
                        if (val != null && val.isEmpty) {
                          return AppLocalization.of(context)
                              .getTranslatedValue("bodField")
                              .toString();
                        }
                        return null;
                      },
                      onChanged: (val) {
                        setState(() => bod = val);
                      },
                      decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          prefixIcon: Icon(
                            Icons.calendar_today_rounded,
                            color: Colors.indigo,
                          ),
                          hintText: AppLocalization.of(context)
                              .getTranslatedValue("patientBod")
                              .toString(),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelStyle: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue[200]),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                              borderSide: BorderSide(
                                color: Colors.indigo,
                                width: 2.0,
                              ))),
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    TextFormField(
                      readOnly: true,
                      initialValue: gender,
                      validator: (String? val) {
                        if (val != null && val.isEmpty) {
                          return AppLocalization.of(context)
                              .getTranslatedValue("genderField")
                              .toString();
                        }
                        return null;
                      },
                      onChanged: (val) {
                        setState(() => gender = val);
                      },
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        prefixIcon: Icon(Icons.safety_divider),
                        hintText: AppLocalization.of(context)
                            .getTranslatedValue("patientGender")
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
                      readOnly: true,
                      initialValue: contactNumber,
                      validator: (String? val) {
                        if (val != null && val.isEmpty) {
                          return AppLocalization.of(context)
                              .getTranslatedValue("phoneField")
                              .toString();
                        }
                        return null;
                      },
                      onChanged: (val) {
                        setState(() => contactNumber = val);
                      },
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        prefixIcon: Icon(Icons.phone),
                        hintText: AppLocalization.of(context)
                            .getTranslatedValue("patientContact")
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
                      readOnly: true,
                      initialValue: address,
                      validator: (String? val) {
                        if (val != null && val.isEmpty) {
                          return AppLocalization.of(context)
                              .getTranslatedValue("addressField")
                              .toString();
                        }
                        return null;
                      },
                      onChanged: (val) {
                        setState(() => address = val);
                      },
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        prefixIcon: Icon(Icons.home),
                        hintText: AppLocalization.of(context)
                            .getTranslatedValue("address")
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
                    SizedBox(
                      height: 20.0,
                    ),
                    Container(
                        margin: const EdgeInsets.fromLTRB(0, 20.0, 30.0, 0),
                        child: TextButton.icon(
                            icon: Icon(Icons.add),
                            label: Text(
                              AppLocalization.of(context)
                                  .getTranslatedValue("checkPreviousVisits")
                                  .toString(),
                            ),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          PatientPreviousCheckUp(
                                              widget.patientInfo!['IC'])));
                            })),
                  ],
                ))));
  }

  Future pickDate() async {
    final initialDate = DateTime.now();
    final newDate = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: DateTime(DateTime.now().year - 100),
        lastDate: DateTime.now());
    if (newDate == null) return;
    setState(() => date = newDate);
  }

  String getText() {
    if (date == null) {
      return 'Select Date';
    } else {
      return '&{date.month}/&{date.day}/${date.year}';
    }
  }
}
