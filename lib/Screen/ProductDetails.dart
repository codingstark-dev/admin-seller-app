import 'package:flutter/material.dart';

class ProductDetaislEdit extends StatefulWidget {
  final int index;

  const ProductDetaislEdit({Key key, this.index}) : super(key: key);
  @override
  _ProductDetaislEditState createState() => _ProductDetaislEditState();
}
Color active = Colors.deepPurple[400];
class _ProductDetaislEditState extends State<ProductDetaislEdit> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title: Text("Edit Product"),
        centerTitle: true,
        backgroundColor: active,
      ) ,
      body: Text(widget.index.toString()),
    );
  }
}