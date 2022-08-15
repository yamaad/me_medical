import 'package:me_medical_app/l10n/app_localization.dart';
import 'package:me_medical_app/screens/checkup_pages/checkup_details.dart';
import 'package:me_medical_app/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// ignore: use_key_in_widget_constructors
class CheckUpList extends StatefulWidget {
  @override
  _CheckUpListState createState() => _CheckUpListState();
}

class _CheckUpListState extends State<CheckUpList> {
  Future getPosts() async {
    var firestore = FirebaseFirestore.instance;

    QuerySnapshot qn = await firestore
        .collection("checkup")
        .doc(AuthService().getCurrentUID())
        .collection('checkUpInfo')
        .get();

    return qn.docs;
  }

  final db = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(AppLocalization.of(context)
            .getTranslatedValue("checkUpList")
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
                child: CircularProgressIndicator(),
              );
            } else {
              return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (_, index) {
                    if (snapshot.data!.length == 0) {
                      return const Center(
                        child: Text("Your inventory is empty :("),
                      );
                    }
                    return Card(
                      child: ListTile(
                          title: Text(
                              snapshot.data[index].data()["Patient Name"],
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                          trailing: Wrap(
                            children: [
                              Text(snapshot.data[index]
                                  .data()["Date"]
                                  .toString())
                            ],
                          ),
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CheckUpDetail(
                                        patientName: snapshot.data[index]
                                            .data()["Patient Name"],
                                        patientIC:
                                            snapshot.data[index].data()["IC"],
                                        date:
                                            snapshot.data[index].data()["Date"],
                                        medicine: snapshot.data[index]
                                            .data()["Medications"]
                                            .cast<String>(),
                                        description: snapshot.data[index]
                                            .data()["Description"],
                                      )))),
                    );
                  });
            }
          }),
    );
  }
}
