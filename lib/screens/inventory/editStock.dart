import 'package:flutter/material.dart';

class EditStock extends StatefulWidget {
  const EditStock({Key? key}) : super(key: key);

  @override
  _EditStockState createState() => _EditStockState();
}

class _EditStockState extends State<EditStock> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          const Text(
            'add to stock',
            style: TextStyle(fontSize: 18),
          ),
          const SizedBox(
            height: 20,
          ),
          TextFormField(),
          const SizedBox(
            height: 5,
          ),
        ],
      ),
    );
  }
}
