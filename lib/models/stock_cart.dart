import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class StockCart {
  String? itemID;
  String? quantity;
  StockCart({
    this.itemID,
    this.quantity,
  });
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
        margin: const EdgeInsets.fromLTRB(45.0, 5.0, 10.0, 2.0),
        child: Row(
          children: [
            Expanded(
                flex: 4,
                child: InputDecorator(
                  decoration:
                      const InputDecoration(border: OutlineInputBorder()),
                  child: DropdownButtonHideUnderline(
                      child: DropdownButton<dynamic>(
                          value: _value1,
                          items: widget.items,
                          isDense: true,
                          onChanged: (value) {
                            setState(() {
                              _value1 = value;
                              widget.cart![widget.index].itemID = _value1;
                            });
                          })),
                )),
            const SizedBox(
              height: 30,
              width: 40,
            ),
            Expanded(
                flex: 1,
                child: TextFormField(
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
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
