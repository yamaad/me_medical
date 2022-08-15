// ignore_for_file: prefer_const_constructors
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:me_medical_app/l10n/app_localization.dart';
import 'package:me_medical_app/screens/checkup_pages/checkup_details.dart';
import 'package:intl/intl.dart';
import 'package:me_medical_app/screens/checkup_pages/checkup_list.dart';
import 'package:me_medical_app/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:me_medical_app/services/database.dart';

// ignore: use_key_in_widget_constructors
class PatientCheckUp extends StatefulWidget {
  @override
  PatientCheckUpState createState() => PatientCheckUpState();
}

class PatientCheckUpState extends State<PatientCheckUp> {
  void refresh() {
    setState(() {});
  }

  final Stream<QuerySnapshot> itemStream = FirebaseFirestore.instance
      .collection('items')
      .doc(AuthService().getCurrentUID())
      .collection('itemInfo')
      .snapshots();

  final Stream<QuerySnapshot> patientStream = FirebaseFirestore.instance
      .collection('patients')
      .doc(AuthService().getCurrentUID())
      .collection('patientInfo')
      .snapshots();

  final _formKey = GlobalKey<FormState>();

  String? description = "";
  String? value = "Not Available";
  String? selectedPatient;
  String? patientIC;
  String? patientName;
  String? patientHint;
  bool error = false;
  List<DropdownMenuItem> patients = [];
  List<DropdownMenuItem> items = [];
  List<CartItem> cart = [];
  List<String> medicine = [];
  List<String> medName = [];
  List<String> medQuantity = [];
  bool isButtonActive = false;
  final AuthService _auth = AuthService();

  final db = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            AppLocalization.of(context).getTranslatedValue("pCheck").toString(),
          ),
          backgroundColor: Colors.indigo,
          elevation: 3,
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream: itemStream,
            builder: (context, snapshot) {
              return StreamBuilder<QuerySnapshot>(
                  stream: patientStream,
                  builder: (context, snapshot2) {
                    items.clear();
                    patients.clear();
                    if (!snapshot.hasData || !snapshot2.hasData) {
                      return Center(
                        child: CupertinoActivityIndicator(),
                      );
                    } else {
                      if (snapshot.data!.size == 0) {
                      } else {
                        if (items.isEmpty) {
                          for (int i = 0; i < snapshot.data!.docs.length; i++) {
                            DocumentSnapshot snap = snapshot.data!.docs[i];
                            items.add(
                              DropdownMenuItem(
                                child: Text(
                                  snap['Item Name'],
                                  style: TextStyle(color: Color(0xff11b719)),
                                ),
                                value: snap['Item Name'] +
                                    " " +
                                    snap.id +
                                    " " +
                                    snap['In Stock'].toString(),
                              ),
                            );
                          }
                        }
                      }
                      if (snapshot2.data!.size == 0) {
                        patientHint = AppLocalization.of(context)
                            .getTranslatedValue("noP")
                            .toString();
                      } else {
                        patientHint = AppLocalization.of(context)
                            .getTranslatedValue("selectPatient")
                            .toString();
                        if (patients.isEmpty) {
                          for (int i = 0;
                              i < snapshot2.data!.docs.length;
                              i++) {
                            DocumentSnapshot snap = snapshot2.data!.docs[i];
                            patients.add(
                              DropdownMenuItem(
                                child: Text(
                                  snap['Patient Name'] + " - " + snap['IC'],
                                  style: TextStyle(color: Color(0xff11b719)),
                                ),
                                value: snap['IC'] + " " + snap['Patient Name'],
                              ),
                            );
                          }
                        }
                      }
                      return SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Container(
                            padding: EdgeInsets.only(bottom: 16.0),
                            child: Column(
                              children: <Widget>[
                                Container(
                                    alignment: Alignment.topLeft,
                                    padding: EdgeInsets.only(
                                        left: 30.0, top: 20.0, bottom: 30.0),
                                    child: Text(
                                        AppLocalization.of(context)
                                            .getTranslatedValue("patientInfo")
                                            .toString(),
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold))),
                                Container(
                                    padding: EdgeInsets.all(20),
                                    child: InputDecorator(
                                        decoration: const InputDecoration(
                                            border: OutlineInputBorder(),
                                            filled: true,
                                            fillColor: Colors.white),
                                        child: DropdownButtonHideUnderline(
                                            child: DropdownButton<dynamic>(
                                                value: selectedPatient,
                                                items: patients,
                                                isDense: true,
                                                onChanged: (val) {
                                                  setState(() {
                                                    isButtonActive = true;
                                                    selectedPatient = val;
                                                  });
                                                },
                                                hint: Text(patientHint!))))),
                                Container(
                                    alignment: Alignment.topLeft,
                                    padding: EdgeInsets.only(
                                        left: 30.0, top: 10.0, bottom: 30.0),
                                    child: Text(
                                        AppLocalization.of(context)
                                            .getTranslatedValue("medication")
                                            .toString(),
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold))),
                                Container(
                                    padding:
                                        EdgeInsets.only(left: 20.0, top: 10.0),
                                    child: Row(children: [
                                      Expanded(
                                        flex: 3,
                                        child: Center(
                                            child: Text(
                                          AppLocalization.of(context)
                                              .getTranslatedValue("mName")
                                              .toString(),
                                          style: TextStyle(fontSize: 16),
                                        )),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Center(
                                            child: Text(
                                          AppLocalization.of(context)
                                              .getTranslatedValue("quantity")
                                              .toString(),
                                          style: TextStyle(fontSize: 16),
                                        )),
                                      ),
                                    ])),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Form(
                                        key: _formKey,
                                        child: ListView.builder(
                                            scrollDirection: Axis.vertical,
                                            shrinkWrap: true,
                                            key: UniqueKey(),
                                            itemCount: cart.length,
                                            itemBuilder:
                                                (BuildContext ctxt, int index) {
                                              return CartWidget(
                                                  cart: cart,
                                                  index: index,
                                                  callback: refresh,
                                                  items: items);
                                            })),
                                    Container(
                                        margin: const EdgeInsets.fromLTRB(
                                            0, 20.0, 30.0, 0),
                                        child: TextButton.icon(
                                          icon: Icon(Icons.add),
                                          label: Text(
                                            AppLocalization.of(context)
                                                .getTranslatedValue("addRow")
                                                .toString(),
                                          ),
                                          onPressed: isButtonActive
                                              ? () {
                                                  setState(() {});
                                                  cart.add(CartItem(
                                                      itemID: "",
                                                      itemName: "",
                                                      quantity: "",
                                                      itemStock: ""));
                                                }
                                              : null,
                                        )),
                                  ],
                                ),
                                SizedBox(
                                  height: 50.0,
                                ),
                                Container(
                                    padding: EdgeInsets.fromLTRB(
                                        30.0, 10.0, 30.0, 30.0),
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                              AppLocalization.of(context)
                                                  .getTranslatedValue(
                                                      "description")
                                                  .toString(),
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold)),
                                          SizedBox(
                                            height: 15.0,
                                          ),
                                          TextField(
                                            decoration: InputDecoration(
                                                filled: true,
                                                fillColor: Colors.white),
                                            autofocus: false,
                                            keyboardType:
                                                TextInputType.multiline,
                                            maxLength: null,
                                            maxLines: null,
                                            onChanged: (value) =>
                                                description = value,
                                          ),
                                          SizedBox(
                                            height: 100.0,
                                          ),
                                        ])),
                                Center(
                                  child: ElevatedButton(
                                      child: Text(
                                        AppLocalization.of(context)
                                            .getTranslatedValue("ccc")
                                            .toString(),
                                      ),
                                      onPressed: isButtonActive
                                          ? () async {
                                              FocusScope.of(context)
                                                  .requestFocus(FocusNode());
                                              if (_formKey.currentState!
                                                  .validate()) {
                                                if (cart.isNotEmpty) {
                                                  for (int i = 0;
                                                      i < cart.length;
                                                      i++) {
                                                    if (int.parse(cart[i]
                                                            .quantity
                                                            .toString()) >
                                                        int.parse(cart[i]
                                                            .itemStock
                                                            .toString())) {
                                                      error = true;
                                                    }
                                                  }

                                                  if (!error) {
                                                    for (int i = 0;
                                                        i < cart.length;
                                                        i++) {
                                                      medName.add(cart[i]
                                                              .itemName! +
                                                          " " +
                                                          cart[i].quantity!);
                                                      medicine.add(cart[i]
                                                              .itemID! +
                                                          " " +
                                                          cart[i].itemName! +
                                                          " " +
                                                          cart[i].quantity! +
                                                          " " +
                                                          cart[i].itemStock!);
                                                      medQuantity.add(
                                                          cart[i].quantity!);
                                                    }

                                                    _auth.updateInventory(
                                                        medicine);
                                                    patientIC = selectedPatient!
                                                        .split(" ")[0];
                                                    patientName =
                                                        selectedPatient!
                                                            .split(" ")[1];

                                                    await DatabaseService(
                                                            uid: AuthService()
                                                                .getCurrentUID())
                                                        .updateCheckUpList(
                                                            patientName!,
                                                            patientIC!,
                                                            DateFormat(
                                                                    'yyyy/MM/dd hh:mm a')
                                                                .format(DateTime
                                                                    .now())
                                                                .toString(),
                                                            medName,
                                                            description!);

                                                    await DatabaseService(
                                                            uid: AuthService()
                                                                .getCurrentUID())
                                                        .updatePatientCheckUpList(
                                                            patientName!,
                                                            patientIC!,
                                                            DateFormat(
                                                                    'yyyy/MM/dd hh:mm a')
                                                                .format(DateTime
                                                                    .now())
                                                                .toString(),
                                                            medName,
                                                            description!);

                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) => CheckUpDetail(
                                                                patientName:
                                                                    patientName,
                                                                patientIC:
                                                                    patientIC,
                                                                date: DateFormat(
                                                                        'yyyy/MM/dd hh:mm a')
                                                                    .format(
                                                                        DateTime
                                                                            .now())
                                                                    .toString(),
                                                                medicine:
                                                                    medName,
                                                                description:
                                                                    description))).then(
                                                        (value) {
                                                      Navigator.pushReplacement(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (BuildContext
                                                                      context) =>
                                                                  super
                                                                      .widget));
                                                    });
                                                  } else {
                                                    showDialog(
                                                      barrierDismissible: true,
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return CupertinoAlertDialog(
                                                          title: Text(
                                                              AppLocalization.of(
                                                                      context)
                                                                  .getTranslatedValue(
                                                                      "error")
                                                                  .toString()),
                                                          content: Text(AppLocalization
                                                                  .of(context)
                                                              .getTranslatedValue(
                                                                  "errorStock")
                                                              .toString()),
                                                          actions: [
                                                            TextButton(
                                                              child: Text("OK"),
                                                              onPressed: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                            ),
                                                          ],
                                                        );
                                                      },
                                                    ).then((value) {
                                                      Navigator.pushReplacement(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (BuildContext
                                                                      context) =>
                                                                  super
                                                                      .widget));
                                                    });
                                                  }
                                                } else {
                                                  patientIC = selectedPatient!
                                                      .split(" ")[0];
                                                  patientName = selectedPatient!
                                                      .split(" ")[1];

                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) => CheckUpDetail(
                                                              patientName:
                                                                  patientName,
                                                              patientIC:
                                                                  patientIC,
                                                              date: DateFormat(
                                                                      'yyyy/MM/dd hh:mm a')
                                                                  .format(
                                                                      DateTime
                                                                          .now())
                                                                  .toString(),
                                                              medicine: medName,
                                                              description:
                                                                  description))).then(
                                                      (value) {
                                                    Navigator.pushReplacement(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (BuildContext
                                                                    context) =>
                                                                super.widget));
                                                  });
                                                }
                                              } else {
                                                showDialog(
                                                  barrierDismissible: true,
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return CupertinoAlertDialog(
                                                      title: Text(AppLocalization
                                                              .of(context)
                                                          .getTranslatedValue(
                                                              "error")
                                                          .toString()),
                                                      content: Text(
                                                          AppLocalization.of(
                                                                  context)
                                                              .getTranslatedValue(
                                                                  "errorEmpty")
                                                              .toString()),
                                                      actions: [
                                                        TextButton(
                                                          child: Text("OK"),
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                ).then((value) {
                                                  Navigator.pushReplacement(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (BuildContext
                                                                  context) =>
                                                              super.widget));
                                                });
                                              }
                                            }
                                          : null,
                                      style: ElevatedButton.styleFrom(
                                          primary: Colors.indigo)),
                                ),
                                SizedBox(height: 10.0),
                              ],
                            ),
                          ));
                    }
                  });
            }),
        floatingActionButton: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SizedBox(
                height: 20.0,
              ),
              FloatingActionButton.extended(
                  heroTag: null,
                  elevation: 10.0,
                  label: Text(
                    AppLocalization.of(context)
                        .getTranslatedValue("checkH")
                        .toString(),
                  ),
                  icon: Icon(Icons.list),
                  backgroundColor: Colors.blueAccent[800],
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CheckUpList())).then((value) {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => super.widget));
                    });
                  })
            ]));
  }
}

class CartItem {
  String? itemID;
  String? itemName;
  String? itemStock;
  String? quantity;
  CartItem({this.itemID, this.itemName, this.quantity, this.itemStock});
}

// ignore: must_be_immutable
class CartWidget extends StatefulWidget {
  List<DropdownMenuItem> items;
  List<CartItem>? cart;
  int index;
  VoidCallback? callback;

  CartWidget(
      {Key? key,
      this.cart,
      required this.index,
      this.callback,
      required this.items})
      : super(key: key);
  @override
  _CartWidgetState createState() => _CartWidgetState();
}

class _CartWidgetState extends State<CartWidget> {
  String? _value1;
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.fromLTRB(45.0, 5.0, 10.0, 2.0),
        child: Row(
          children: [
            Expanded(
                flex: 4,
                child: InputDecorator(
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white),
                  child: DropdownButtonHideUnderline(
                      child: DropdownButtonFormField<dynamic>(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                          value: _value1,
                          items: widget.items,
                          isDense: true,
                          onChanged: (value) {
                            setState(() {
                              _value1 = value;
                              widget.cart![widget.index].itemName =
                                  _value1!.split(" ")[0];
                              widget.cart![widget.index].itemID =
                                  _value1!.split(" ")[1];
                              widget.cart![widget.index].itemStock =
                                  _value1!.split(" ")[2];
                            });
                          })),
                )),
            SizedBox(
              height: 30,
              width: 40,
            ),
            Expanded(
                flex: 1,
                child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderSide: BorderSide(),
                      ),
                      //fillColor: Colors.green
                    ),
                    onChanged: (String? value) {
                      setState(() {
                        widget.cart![widget.index].quantity = value;
                      });
                    })),
            Expanded(
              child: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  setState(() {
                    widget.cart!.removeAt(widget.index);
                    widget.callback!();
                  });
                },
              ),
            )
          ],
        ));
  }
}
