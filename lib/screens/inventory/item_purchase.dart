import 'package:me_medical_app/l10n/app_localization.dart';
import 'package:me_medical_app/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// ignore: use_key_in_widget_constructors
class ItemPurchase extends StatefulWidget {
  String itemID;

  ItemPurchase(this.itemID);
  @override
  _ItemPurchaseState createState() => _ItemPurchaseState();
}

class _ItemPurchaseState extends State<ItemPurchase> {
  Future getPosts() async {
    var firestore = FirebaseFirestore.instance;

    QuerySnapshot qn = await firestore
        .collection("items")
        .doc(AuthService().getCurrentUID())
        .collection('itemInfo')
        .doc(widget.itemID)
        .collection('itemPurchaseInfo')
        .get();

    return qn.docs;
  }

  String itemName = "";
  final db = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(AppLocalization.of(context)
            .getTranslatedValue("record")
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
      body: FutureBuilder(
          future: getPosts(),
          builder: (_, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: Text("Loading"),
              );
            } else {
              return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (_, index) {
                    if (snapshot.data!.length == 0) {
                      return const Center(
                        child: Text("No purchase recorded"),
                      );
                    }
                    return Card(
                      child: ListTile(
                        title: Text(
                          AppLocalization.of(context)
                                  .getTranslatedValue("quantity")
                                  .toString() +
                              " : " +
                              snapshot.data[index].data()["Quantity"] +
                              AppLocalization.of(context)
                                  .getTranslatedValue("price")
                                  .toString() +
                              " : " +
                              snapshot.data[index].data()["Price"],
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        trailing: Wrap(
                          children: [
                            Text(snapshot.data[index].data()["Date"].toString(),
                                style: TextStyle(fontWeight: FontWeight.bold))
                          ],
                        ),
                      ),
                    );
                  });
            }
          }),
    );
  }
}
