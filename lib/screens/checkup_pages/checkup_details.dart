import 'package:flutter/material.dart';
import 'package:me_medical_app/l10n/app_localization.dart';

class CheckUpDetail extends StatefulWidget {
  String? patientName;
  String? patientIC;
  String? date;
  List<String> medicine;
  String? description;

  CheckUpDetail(
      {Key? key,
      this.patientName,
      this.patientIC,
      this.date,
      required this.medicine,
      this.description})
      : super(key: key);

  @override
  CheckUpDetailState createState() => CheckUpDetailState();
}

class CheckUpDetailState extends State<CheckUpDetail> {
  List<Widget> textWidgetList = <Widget>[];

  @override
  Widget build(BuildContext context) {
    if (textWidgetList.isEmpty) {
      for (int i = 0; i < widget.medicine.length; i++) {
        textWidgetList.add(Text(widget.medicine[i],
            style: const TextStyle(
              fontSize: 16.0,
            )));
      }
    }
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
              AppLocalization.of(context)
                  .getTranslatedValue("checkUpDetails")
                  .toString(),
              overflow: TextOverflow.ellipsis),
          backgroundColor: Colors.indigo,
          elevation: 3,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              widget.medicine.clear();
              Navigator.pop(context);
            },
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(5.0)),
          padding: const EdgeInsets.only(
              left: 30.0, right: 20.0, top: 40.0, bottom: 20.0),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: Row(children: [
                  Expanded(
                      flex: 3,
                      child: Text(
                          AppLocalization.of(context)
                              .getTranslatedValue("patientName")
                              .toString(),
                          style: const TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.bold))),
                  Expanded(
                      flex: 3,
                      child: Text(widget.patientName!,
                          style: const TextStyle(
                            fontSize: 16.0,
                          )))
                ]),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: Row(children: [
                    Expanded(
                        flex: 3,
                        child: Text(
                            AppLocalization.of(context)
                                .getTranslatedValue("patientID")
                                .toString(),
                            style: const TextStyle(
                                fontSize: 18.0, fontWeight: FontWeight.bold))),
                    Expanded(
                        flex: 3,
                        child: Text(widget.patientIC!,
                            style: const TextStyle(
                              fontSize: 16.0,
                            ))),
                  ])),
              const SizedBox(
                height: 20,
              ),
              Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: Row(children: [
                    Expanded(
                        flex: 3,
                        child: Text(
                            AppLocalization.of(context)
                                .getTranslatedValue("checkUpDate")
                                .toString(),
                            style: const TextStyle(
                                fontSize: 18.0, fontWeight: FontWeight.bold))),
                    Expanded(
                        flex: 3,
                        child: Text(widget.date!,
                            style: const TextStyle(
                              fontSize: 16.0,
                            ))),
                  ])),
              const SizedBox(
                height: 20,
              ),
              Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: Row(children: [
                    Expanded(
                        flex: 3,
                        child: Text(
                            AppLocalization.of(context)
                                .getTranslatedValue("medication")
                                .toString(),
                            style: const TextStyle(
                                fontSize: 18.0, fontWeight: FontWeight.bold))),
                    Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: textWidgetList,
                        )),
                  ])),
              const SizedBox(
                height: 20,
              ),
              Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: Row(children: [
                    Expanded(
                        flex: 3,
                        child: Text(
                            AppLocalization.of(context)
                                .getTranslatedValue("description")
                                .toString(),
                            style: const TextStyle(
                                fontSize: 16.0, fontWeight: FontWeight.bold))),
                    Expanded(
                        flex: 3,
                        child: Text(widget.description!,
                            style: const TextStyle(
                              fontSize: 16.0,
                            ))),
                  ])),
            ],
          ),
        ));
  }
}
