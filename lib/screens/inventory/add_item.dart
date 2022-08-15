// ignore_for_file: prefer_const_constructors
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:me_medical_app/l10n/app_localization.dart';
import 'package:me_medical_app/screens/inventory/inventory.dart';
import 'package:me_medical_app/services/auth.dart';
import 'package:flutter/services.dart';

// ignore: use_key_in_widget_constructors
class AddItemPage extends StatefulWidget {
  @override
  _AddItemPageState createState() => _AddItemPageState();
}

class _AddItemPageState extends State<AddItemPage> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  String itemName = '';
  String buyPrice = '';
  String sellPrice = '';
  String inStock = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(AppLocalization.of(context)
              .getTranslatedValue("addItem")
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
        body: Container(
            padding: EdgeInsets.only(
                left: 30.0, right: 20.0, top: 20.0, bottom: 20.0),
            child: Form(
                key: _formKey,
                child: Column(children: <Widget>[
                  TextFormField(
                    onChanged: (val) {
                      setState(() => itemName = val);
                    },
                    validator: (String? val) {
                      if (val != null && val.isEmpty) {
                        return AppLocalization.of(context)
                            .getTranslatedValue("medicineField")
                            .toString();
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      prefixIcon: Icon(
                        Icons.medication,
                      ),
                      hintText: AppLocalization.of(context)
                          .getTranslatedValue("mName")
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
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^\d+\.?\d{0,2}'))
                    ],
                    keyboardType: TextInputType.number,
                    validator: (String? val) {
                      if (val != null && val.isEmpty) {
                        return AppLocalization.of(context)
                            .getTranslatedValue("buyPriceField")
                            .toString();
                      }
                      return null;
                    },
                    onChanged: (val) {
                      setState(() => buyPrice = val);
                    },
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      prefixIcon: Icon(
                        Icons.attach_money,
                        color: Colors.green,
                      ),
                      hintText: AppLocalization.of(context)
                          .getTranslatedValue("buyPrice")
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
                            .getTranslatedValue("sellPriceField")
                            .toString();
                      }
                      return null;
                    },
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^\d+\.?\d{0,2}'))
                    ],
                    keyboardType: TextInputType.number,
                    onChanged: (val) {
                      setState(() => sellPrice = val);
                    },
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      prefixIcon: Icon(
                        Icons.attach_money,
                        color: Colors.red,
                      ),
                      hintText: AppLocalization.of(context)
                          .getTranslatedValue("sellPrice")
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
                            .getTranslatedValue("stockField")
                            .toString();
                      }
                      return null;
                    },
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    keyboardType: TextInputType.number,
                    onChanged: (val) {
                      setState(() => inStock = val);
                    },
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      prefixIcon: Icon(CupertinoIcons.cube_box_fill),
                      hintText: AppLocalization.of(context)
                          .getTranslatedValue("inStock")
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
                              .getTranslatedValue("addItem")
                              .toString()),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              _auth.addItem(itemName, double.parse(buyPrice),
                                  double.parse(sellPrice), int.parse(inStock));
                              Navigator.of(context).pushAndRemoveUntil(
                                CupertinoPageRoute(
                                  builder: (BuildContext context) {
                                    return InventoryPage();
                                  },
                                ),
                                (_) => false,
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              primary: Colors.blueAccent))),
                  SizedBox(
                    height: 25.0,
                  ),
                ]))));
  }
}
