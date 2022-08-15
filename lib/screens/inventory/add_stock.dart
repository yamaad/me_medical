// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:me_medical_app/l10n/app_localization.dart';
import 'package:me_medical_app/screens/inventory/inventory.dart';
import 'package:me_medical_app/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:me_medical_app/services/database.dart';
import 'package:intl/intl.dart';

// ignore: use_key_in_widget_constructors
class AddStock extends StatefulWidget {
  @override
  AddStockState createState() => AddStockState();
}

class AddStockState extends State<AddStock> {
  void refresh() {
    setState(() {});
  }

  final Stream<QuerySnapshot> itemStream = FirebaseFirestore.instance
      .collection('items')
      .doc(AuthService().getCurrentUID())
      .collection('itemInfo')
      .snapshots();

  List<DropdownMenuItem> items = [];

  List<StockCart> cart = [];
  List<String> medQuantity = [];
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            AppLocalization.of(context)
                .getTranslatedValue("addStock")
                .toString(),
          ),
          backgroundColor: Colors.indigo,
          elevation: 3,
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream: itemStream,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
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
                            value:
                                snap.id + " " + snap['Buy Price'].toString()),
                      );
                    }
                  }
                }
                return SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Container(
                      padding: EdgeInsets.all(10.0),
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(CupertinoIcons.info, color: Colors.blue),
                              SizedBox(
                                width: 20,
                              ),
                              Expanded(
                                child: Text(
                                    AppLocalization.of(context)
                                        .getTranslatedValue("addStockInfo")
                                        .toString(),
                                    style: TextStyle(fontSize: 14)),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 30,
                            width: 30,
                          ),
                          Container(
                              padding: EdgeInsets.only(left: 20.0, top: 10.0),
                              child: Row(children: [
                                Expanded(
                                  flex: 2,
                                  child: Center(
                                      child: Text(
                                    AppLocalization.of(context)
                                        .getTranslatedValue("mName")
                                        .toString(),
                                    style: TextStyle(fontSize: 16),
                                  )),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Center(
                                      child: Text(
                                    AppLocalization.of(context)
                                        .getTranslatedValue("quantity")
                                        .toString(),
                                    style: TextStyle(fontSize: 16),
                                  )),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Center(
                                      child: Text(
                                    AppLocalization.of(context)
                                        .getTranslatedValue("price")
                                        .toString(),
                                    style: TextStyle(fontSize: 16),
                                  )),
                                ),
                                SizedBox(
                                  width: 70,
                                )
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
                                        return StockCartWidget(
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
                                    onPressed: () {
                                      setState(() {});
                                      cart.add(StockCart(
                                          itemID: "", quantity: "", price: ""));
                                    },
                                  )),
                            ],
                          ),
                          Center(
                              child: ElevatedButton(
                                  child: Text(
                                    AppLocalization.of(context)
                                        .getTranslatedValue("addStock")
                                        .toString(),
                                  ),
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()) {
                                      for (int i = 0; i < cart.length; i++) {
                                        await DatabaseService(
                                                uid: AuthService()
                                                    .getCurrentUID())
                                            .updateStock(
                                                cart[i].itemID,
                                                int.parse(cart[i]
                                                    .quantity
                                                    .toString()));

                                        await DatabaseService(
                                                uid: AuthService()
                                                    .getCurrentUID())
                                            .updateItemPurchase(
                                                cart[i].itemID.toString(),
                                                DateFormat('yyyy/MM/dd hh:mm a')
                                                    .format(DateTime.now())
                                                    .toString(),
                                                cart[i].quantity.toString(),
                                                cart[i].totalPrice.toString());
                                      }

                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => InventoryPage(),
                                        ),
                                      );
                                    } else {
                                      showDialog(
                                        barrierDismissible: true,
                                        context: context,
                                        builder: (BuildContext context) {
                                          return CupertinoAlertDialog(
                                            title: Text(
                                                AppLocalization.of(context)
                                                    .getTranslatedValue("error")
                                                    .toString()),
                                            content: Text(
                                                AppLocalization.of(context)
                                                    .getTranslatedValue(
                                                        "errorEmpty")
                                                    .toString()),
                                            actions: [
                                              TextButton(
                                                child: Text("OK"),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                            ],
                                          );
                                        },
                                      ).then((value) {
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        super.widget));
                                      });
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                      primary: Colors.indigo))),
                        ],
                      ),
                    ));
              }
            }));
  }
}

class StockCart {
  String? itemID;
  String? quantity;
  String? price;
  double totalPrice = 0;
  StockCart({this.itemID, this.quantity, this.price});
}

// ignore: must_be_immutable
class StockCartWidget extends StatefulWidget {
  List<DropdownMenuItem> items;
  List<StockCart>? cart;
  int index;
  VoidCallback? callback;

  StockCartWidget(
      {Key? key,
      this.cart,
      required this.index,
      this.callback,
      required this.items})
      : super(key: key);
  @override
  _StockCartWidgettState createState() => _StockCartWidgettState();
}

class _StockCartWidgettState extends State<StockCartWidget> {
  String? _value1;
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.fromLTRB(20.0, 5.0, 10.0, 2.0),
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
                              return AppLocalization.of(context)
                                  .getTranslatedValue("pickItem")
                                  .toString();
                            }
                            return null;
                          },
                          value: _value1,
                          items: widget.items,
                          isDense: true,
                          onChanged: (value) {
                            if (widget.cart![widget.index].quantity == "") {
                              setState(() {
                                _value1 = value;
                                widget.cart![widget.index].itemID =
                                    _value1!.split(" ")[0];
                                widget.cart![widget.index].price =
                                    _value1!.split(" ")[1];
                                widget.cart![widget.index].totalPrice = 0;
                              });
                            } else if (value!.isEmpty) {
                              setState(() {
                                _value1 = value;
                                widget.cart![widget.index].itemID =
                                    _value1!.split(" ")[0];
                                widget.cart![widget.index].price =
                                    _value1!.split(" ")[1];
                                widget.cart![widget.index].totalPrice = 0;
                              });
                            } else {
                              setState(() {
                                _value1 = value;
                                widget.cart![widget.index].itemID =
                                    _value1!.split(" ")[0];
                                widget.cart![widget.index].price =
                                    _value1!.split(" ")[1];
                                widget.cart![widget.index].totalPrice =
                                    double.parse(widget
                                            .cart![widget.index].price
                                            .toString()) *
                                        double.parse(widget
                                            .cart![widget.index].quantity
                                            .toString());
                              });
                            }
                          })),
                )),
            const SizedBox(
              height: 30,
              width: 20,
            ),
            Expanded(
                flex: 2,
                child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppLocalization.of(context)
                            .getTranslatedValue("enterValue")
                            .toString();
                      }
                      return null;
                    },
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderSide: BorderSide(),
                      ),
                      //fillColor: Colors.green
                    ),
                    onChanged: (String? value) {
                      if (widget.cart![widget.index].price == "") {
                        setState(() {
                          widget.cart![widget.index].quantity = value;
                          widget.cart![widget.index].totalPrice = 0;
                        });
                      } else if (value!.isEmpty) {
                        setState(() {
                          widget.cart![widget.index].quantity = value;
                          widget.cart![widget.index].totalPrice = 0;
                        });
                      } else {
                        setState(() {
                          widget.cart![widget.index].quantity = value;
                          widget.cart![widget.index].totalPrice = double.parse(
                                  value.toString()) *
                              double.parse(
                                  widget.cart![widget.index].price.toString());
                        });
                      }
                    })),
            const SizedBox(
              height: 30,
              width: 30,
            ),
            Expanded(
                flex: 2,
                child: Text(widget.cart![widget.index].totalPrice.toString())),
            Expanded(
              child: IconButton(
                icon: const Icon(Icons.delete),
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
