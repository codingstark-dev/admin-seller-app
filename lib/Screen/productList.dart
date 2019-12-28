import 'package:flutter/material.dart';

class ProductList extends StatefulWidget {
  @override
  _ProductListState createState() => _ProductListState();
}

Color active = Colors.deepPurple[400];

class _ProductListState extends State<ProductList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Product List"),
        backgroundColor: active,
        centerTitle: true,
      ),
      body: StreamBuilder<Object>(
          stream: null,
          builder: (context, snapshot) {
            return ListView.builder(itemCount: 10,
              itemBuilder: (BuildContext context, int index) => ListTile(
                title: Text("data"),
                leading: Icon(Icons.ac_unit),
                subtitle: Text("Price"),
                trailing: Text("data"),
                
              ),
            );
          }),
    );
  }
}
