import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sellerapp/model/user.dart';
import 'package:sellerapp/service/dbapi.dart';
import 'package:sellerapp/service/streamfiles.dart';

class ProductList extends StatefulWidget {
  @override
  _ProductListState createState() => _ProductListState();
}

Color active = Colors.deepPurple[400];

class _ProductListState extends State<ProductList> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    final db = DatabaseService(uid: user?.uid);
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Product List"),
        backgroundColor: active,
        centerTitle: true,
      ),
      body: StreamBuilder(
          initialData: null,
          stream: Firestore.instance
              .collection("ProductListID")
              .document(user.uid)
              .collection(user.uid)
              .where("PersonID", isEqualTo: user.uid)
              .snapshots(),
          builder: (context, snapshot) {
            return ListView.builder(
                itemCount: snapshot.data.documents?.length,
                itemBuilder: (BuildContext context, int index) {
                  final List<DocumentSnapshot> documents =
                      snapshot.data?.documents;

                  if (snapshot.hasData) {
                    return ListTile(
                      title: Text(documents[index]["price"].toString()),
                      leading: Icon(Icons.ac_unit),
                      subtitle: Text(documents[index]['images'].toString()),
                    );
                  } else {}
                });
          }),
    );
  }
}
