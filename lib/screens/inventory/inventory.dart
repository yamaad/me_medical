// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:me_medical_app/l10n/app_localization.dart';
import 'package:me_medical_app/screens/inventory/add_item.dart';
import 'package:me_medical_app/screens/inventory/add_stock.dart';
import 'package:me_medical_app/screens/inventory/item_purchase.dart';
import 'package:me_medical_app/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:me_medical_app/services/database.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

// ignore: use_key_in_widget_constructors
class InventoryPage extends StatefulWidget {
  @override
  _InventoryPageState createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  TextEditingController editingController = TextEditingController();
  Future getPosts() async {
    var firestore = FirebaseFirestore.instance;

    QuerySnapshot qn = await firestore
        .collection("items")
        .doc(AuthService().getCurrentUID())
        .collection('itemInfo')
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
              .getTranslatedValue("medicalIn")
              .toString()),
          elevation: 3,
        ),
        body: FutureBuilder(
            future: getPosts(),
            builder: (_, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: Text("Your inventory is empty :("),
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
                          padding: const EdgeInsets.all(8.0),
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
                                    margin: EdgeInsets.all(10),
                                    child: Align(
                                        alignment: Alignment.center,
                                        child: ListTile(
                                            title: Text(
                                                snapshot.data[index]
                                                    .data()["Item Name"],
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            trailing: Wrap(
                                              children: [
                                                Text(
                                                    snapshot.data[index]
                                                        .data()["In Stock"]
                                                        .toString(),
                                                    style: TextStyle(
                                                        color: (snapshot.data[
                                                                            index]
                                                                        .data()[
                                                                    "In Stock"] <
                                                                10)
                                                            ? Colors.red
                                                            : Colors.black,
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold))
                                              ],
                                            ),
                                            onTap: () {
                                              editingController.clear();
                                              pushNewScreen(
                                                context,
                                                screen: ItemDetailPage(
                                                    itemInfo:
                                                        snapshot.data[index]),
                                                withNavBar:
                                                    true, // OPTIONAL VALUE. True by default.
                                                pageTransitionAnimation:
                                                    PageTransitionAnimation
                                                        .cupertino,
                                              );
                                            })));
                              } else if (snapshot.data[index]["Item Name"]
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
                                                        .data()["Item Name"],
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                trailing: Wrap(
                                                  children: [
                                                    Text(
                                                        snapshot.data[index]
                                                            .data()["In Stock"]
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
                                                              ItemDetailPage(
                                                                itemInfo:
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: FloatingActionButton.extended(
                    heroTag: "btn2",
                    elevation: 0.0,
                    label: Text(AppLocalization.of(context)
                        .getTranslatedValue("addItem")
                        .toString()),
                    icon: Icon(Icons.add),
                    backgroundColor: Colors.blueAccent[900],
                    onPressed: () {
                      pushNewScreen(
                        context,
                        screen: AddItemPage(),
                        withNavBar: true, // OPTIONAL VALUE. True by default.
                        pageTransitionAnimation:
                            PageTransitionAnimation.cupertino,
                      );
                    })),
            //!maaaaaaaa{
            FloatingActionButton.extended(
                heroTag: "btn1",
                elevation: 0.0,
                label: Text(AppLocalization.of(context)
                    .getTranslatedValue("addStock")
                    .toString()),
                icon: Icon(CupertinoIcons.cube_box),
                backgroundColor: Colors.indigo[700],
                onPressed: () {
                  pushNewScreen(
                    context,
                    screen: AddStock(),
                    withNavBar: true, // OPTIONAL VALUE. True by default.
                    pageTransitionAnimation: PageTransitionAnimation.cupertino,
                  );
                }),
            //! maaaaaaaaaa}
          ],
        ));
  }
}

class ItemDetailPage extends StatefulWidget {
  final DocumentSnapshot? itemInfo;

  ItemDetailPage({this.itemInfo});

  @override
  _ItemDetailPageState createState() => _ItemDetailPageState();
}

class _ItemDetailPageState extends State<ItemDetailPage> {
  final _formKey = GlobalKey<FormState>();
  String itemID = '';
  String itemName = '';
  String buyPrice = '';
  String sellPrice = '';
  String inStock = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    itemID = widget.itemInfo!.id;
    itemName = widget.itemInfo!['Item Name'];
    buyPrice = widget.itemInfo!['Buy Price'].toString();
    sellPrice = widget.itemInfo!['Sell Price'].toString();
    inStock = widget.itemInfo!['In Stock'].toString();

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(widget.itemInfo!['Item Name'],
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
                    barrierDismissible: true,
                    useRootNavigator: false,
                    context: context,
                    builder: (BuildContext context) {
                      return CupertinoAlertDialog(
                        title: Text(AppLocalization.of(context)
                                .getTranslatedValue("confirmDelete")
                                .toString() +
                            widget.itemInfo!['Item Name'] +
                            "?"),
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
                                  .deleteItem(widget.itemInfo!.id);

                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => InventoryPage(),
                                ),
                              );
                            },
                          )
                        ],
                      );
                    });
              },
            ),
          ],
        ),
        body: Container(
            padding: EdgeInsets.only(
                left: 30.0, right: 20.0, top: 20.0, bottom: 20.0),
            child: Form(
                key: _formKey,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      TextFormField(
                        initialValue: itemName,
                        onChanged: (val) => itemName = val,
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
                              .getTranslatedValue("itemName")
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
                        initialValue: buyPrice,
                        validator: (String? val) {
                          if (val != null && val.isEmpty) {
                            return AppLocalization.of(context)
                                .getTranslatedValue("buyPriceField")
                                .toString();
                          }
                          return null;
                        },
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^\d+\.?\d{0,2}'))
                        ],
                        keyboardType: TextInputType.number,
                        onChanged: (val) => buyPrice = val,
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          prefixIcon: Icon(
                            Icons.attach_money,
                            color: Colors.red,
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
                        initialValue: sellPrice,
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
                        onChanged: (val) => sellPrice = val,
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          prefixIcon: Icon(
                            Icons.attach_money,
                            color: Colors.green,
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
                        initialValue: inStock,
                        validator: (String? val) {
                          if (val != null && val.isEmpty) {
                            return AppLocalization.of(context)
                                .getTranslatedValue("stockField")
                                .toString();
                          }
                          return null;
                        },
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        keyboardType: TextInputType.number,
                        onChanged: (val) => inStock = val,
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          prefixIcon: Icon(
                            CupertinoIcons.cube_box_fill,
                          ),
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
                      Container(
                          child: TextButton.icon(
                        icon: Icon(
                          Icons.history,
                          color: Colors.blueAccent[800],
                        ),
                        label: Text(
                          AppLocalization.of(context)
                              .getTranslatedValue("record")
                              .toString(),
                          style: TextStyle(color: Colors.indigo[800]),
                        ),
                        onPressed: () {
                          pushNewScreen(
                            context,
                            screen: ItemPurchase(itemID),
                            withNavBar:
                                true, // OPTIONAL VALUE. True by default.
                            pageTransitionAnimation:
                                PageTransitionAnimation.cupertino,
                          );
                        },
                      )),
                      SizedBox(
                        height: 30.0,
                      ),
                      Center(
                          child: ElevatedButton(
                              child: Text(AppLocalization.of(context)
                                  .getTranslatedValue("update")
                                  .toString()),
                              onPressed: () async {
                                print(itemName);

                                if (_formKey.currentState!.validate()) {
                                  await DatabaseService(
                                          uid: AuthService().getCurrentUID())
                                      .updateItemInformation(
                                          widget.itemInfo!.id,
                                          itemName,
                                          double.parse(buyPrice),
                                          double.parse(sellPrice),
                                          int.parse(inStock));

                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              InventoryPage()));
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.blueAccent))),
                    ]))));
  }
}
