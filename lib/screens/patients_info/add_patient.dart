// ignore_for_file: prefer_const_constructors
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:me_medical_app/l10n/app_localization.dart';
import 'package:me_medical_app/screens/patients_info/patient_list.dart';
import 'package:me_medical_app/services/auth.dart';

import 'package:intl/intl.dart';

// ignore: use_key_in_widget_constructors
class AddPatientPage extends StatefulWidget {
  @override
  _AddPatientPageState createState() => _AddPatientPageState();
}

class _AddPatientPageState extends State<AddPatientPage> {
  final TextEditingController _textEditingController = TextEditingController();
  final TextEditingController _textEditingController2 = TextEditingController();
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  String patientName = '';
  String ic = '';
  String bod = '';
  DateTime date = DateTime.now();
  String gender = '';
  String contactNumber = '';
  String address = '';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          centerTitle: true,
          title: Text(AppLocalization.of(context)
              .getTranslatedValue("addP")
              .toString()),
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
        ),
        body: SingleChildScrollView(
            child: Container(
                padding: EdgeInsets.only(
                    left: 30.0, right: 20.0, top: 20.0, bottom: 20.0),
                child: Form(
                    key: _formKey,
                    child: Column(children: <Widget>[
                      TextFormField(
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
                        controller: _textEditingController,
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
                        onTap: () async {
                          FocusScope.of(context).requestFocus(FocusNode());
                          // Show Date Picker Here
                          await pickDate();

                          _textEditingController.text =
                              DateFormat('yyyy/MM/dd').format(date);
                          bod =
                              DateFormat('yyyy/MM/dd').format(date).toString();
                        },
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      TextFormField(
                        controller: _textEditingController2,
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
                        onTap: () {
                          showModalBottomSheet(
                              context: context,
                              builder: (BuildContext context) {
                                return Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      ListTile(
                                          title: Text("Male"),
                                          onTap: () {
                                            setState(() {
                                              gender = "Male";
                                              Navigator.pop(context);
                                              _textEditingController2.text =
                                                  gender;
                                            });
                                          }),
                                      ListTile(
                                          title: Text("Female"),
                                          onTap: () {
                                            setState(() {
                                              gender = "Female";
                                              Navigator.pop(context);
                                              _textEditingController2.text =
                                                  gender;
                                            });
                                          })
                                    ]);
                              });
                          FocusScope.of(context).requestFocus(FocusNode());
                        },
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
                      Center(
                          child: ElevatedButton(
                              child: Text(AppLocalization.of(context)
                                  .getTranslatedValue("addP")
                                  .toString()),
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  _auth.addPatient(patientName, ic, bod, gender,
                                      contactNumber, address);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              PatientListPage()));
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.indigo))),
                      SizedBox(
                        height: 25.0,
                      ),
                    ])))));
  }
}
