import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:sellerapp/Screen/ProductDetails.dart';
import 'package:sellerapp/model/user.dart';

class ProductList extends StatefulWidget {
  final payload;

  const ProductList({Key key, this.payload}) : super(key: key);
  @override
  _ProductListState createState() => _ProductListState();
}

Color active = Colors.deepPurple[400];

class _ProductListState extends State<ProductList> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    // final db = DatabaseService(uid: user?.uid);

    return Scaffold(
      appBar: AppBar(
        title: Text("Your Product List"),
        backgroundColor: active,
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance
              .collection("ProductListID")
              .document(user.uid)
              .collection(user.uid)
              .where("PersonID", isEqualTo: user.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.data.documents.length > 0) {
                return ListView.builder(
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (BuildContext context, int index) {
                      //list snapshot
                      final List<DocumentSnapshot> document =
                          snapshot?.data?.documents;
                      //document id
                      final documentID =
                          snapshot?.data?.documents[index]?.documentID;
                      // print(documentID.toString());
                      //firestore

                      if (snapshot.hasData &&
                          snapshot.data.documents.length > 0) {
                        return Card(
                          child: ListTile(
                            isThreeLine: true,
                            title: Text(document[index]["price"].toString()),
                            leading: Image.network(
                              document[index]["images"][0],
                              fit: BoxFit.fill,
                            ),
                            subtitle:
                                Text(document[index]["ProductName"].toString()),
                            trailing: IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text("Are You Sure?"),
                                        content: Text(
                                            "The Product Where Going to delete Permanetly Means They Will Not Recover"),
                                        actions: <Widget>[
                                          FlatButton(
                                            onPressed: () async {
                                              await Firestore.instance
                                                  .collection("ProductListID")
                                                  .document(user.uid)
                                                  .collection(user.uid)
                                                  .document(documentID)
                                                  .delete()
                                                  .whenComplete(() {
                                                Fluttertoast.showToast(
                                                    msg: "Deleted");
                                                Navigator.pop(context);
                                              });
                                            },
                                            child: Text("Yes"),
                                          ),
                                          FlatButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text("No"),
                                          )
                                        ],
                                      );
                                    });
                              },
                            ),
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        ProductDetaislEdit(
                                          productName: document[index]
                                                  ["ProductName"]
                                              .toString(),
                                          index: index,
                                          price: document[index]["price"],
                                          quantity: document[index]["quantity"],
                                        ))),
                          ),
                        );
                      } else {
                        return Center(
                            child: CircularProgressIndicator(
                          backgroundColor: active,
                        ));
                      }
                    });
              } else {
                return Center(
                    child: Text(
                  "There No Product Added!!",
                  style: TextStyle(
                      color: Colors.grey[350],
                      fontSize: 16,
                      fontWeight: FontWeight.w500),
                ));
              }
            } else {
              return Center(
                child: CircularProgressIndicator(
                  backgroundColor: active,
                ),
              );
            }
          }),
    );
  }
}
