import 'package:carousel_pro/carousel_pro.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:sellerapp/Screen/ProductDetails.dart';
import 'package:sellerapp/model/user.dart';

class ProductList extends StatefulWidget {
  const ProductList({Key key, this.payload}) : super(key: key);

  final payload;

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
                      return Card(
                        child: SizedBox.fromSize(
                          child: Column(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      SizedBox.fromSize(
                                          size: Size(100, 100),
                                          child: Carousel(
                                            overlayShadow: false,
                                            autoplay: false,
                                            boxFit: BoxFit.fill,
                                            dotIncreaseSize: 0,
                                            showIndicator: true,
                                            dotSize: 6,
                                            indicatorBgPadding: 5.0,
                                            dotBgColor: Colors.transparent,
                                            dotSpacing: 10,
                                            images: [
                                              NetworkImage(
                                                  document[index]["images"][0]),
                                              NetworkImage(
                                                  document[index]["images"][1]),
                                              NetworkImage(
                                                  document[index]["images"][2]),
                                            ],
                                          )),
                                    ],
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          4, 0, 0, 10),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          RichText(
                                            overflow: TextOverflow.ellipsis,
                                            text: TextSpan(
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1
                                                    .copyWith(fontSize: 16),
                                                children: [
                                                  TextSpan(
                                                      text: document[index]
                                                              ["ProductName"]
                                                          .toString(),
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500))
                                                ]),
                                          ),
                                          SizedBox(
                                            height: 4,
                                          ),
                                          RichText(
                                            overflow: TextOverflow.fade,
                                            text: TextSpan(
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1
                                                    .copyWith(fontSize: 14),
                                                children: [
                                                  TextSpan(
                                                      text: "Price: ",
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w500)),
                                                  TextSpan(
                                                      text:
                                                          "${document[index]["price"].toString()} ",
                                                      style: TextStyle(
                                                          color:
                                                              Colors.grey[600],
                                                          fontWeight:
                                                              FontWeight.w400)),
                                                  TextSpan(
                                                      text: "₹",
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                ]),
                                          ),
                                          RichText(
                                            text: TextSpan(children: [
                                              TextSpan(
                                                  text: "Category: ",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w500)),
                                              TextSpan(
                                                  text: document[index]
                                                      ["category"],
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w400))
                                            ]),
                                          ),
                                          RichText(
                                            text: TextSpan(children: [
                                              TextSpan(
                                                  text: "Brand: ",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w500)),
                                              TextSpan(
                                                  text: document[index]
                                                      ["brand"],
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w400))
                                            ]),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Column(
                                    children: <Widget>[
                                      IconButton(color: active,
                                        onPressed: () => Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (BuildContext
                                                        context) =>
                                                    ProductDetaislEdit(
                                                      documentID: documentID,
                                                      productName: document[
                                                                  index]
                                                              ["ProductName"]
                                                          .toString(),
                                                      index: index,
                                                      price: document[index]
                                                          ["price"],
                                                      quantity: document[index]
                                                          ["quantity"],
                                                    ))),
                                        icon: Icon(Icons.edit),
                                      ),
                                      IconButton(color: active,
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
                                                            .collection(
                                                                "ProductListID")
                                                            .document(
                                                                documentID)
                                                            .delete()
                                                            .whenComplete(() {
                                                          Fluttertoast.showToast(
                                                              msg: "Deleted");
                                                          Navigator.pop(
                                                              context);
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
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                          size: Size(100, 100),
                        ),
                      );
                      if (snapshot.hasData &&
                          snapshot.data.documents.length > 0) {
                        return Card(
                          child: ListTile(
                            isThreeLine: true,
                            title: RichText(
                              text: TextSpan(
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      .copyWith(fontSize: 16),
                                  children: [
                                    TextSpan(
                                        text: document[index]["ProductName"]
                                            .toString(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500))
                                  ]),
                            ),
                            leading: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                SizedBox(
                                  width: 10,
                                ),
                                GestureDetector(
                                  onTap: () {},
                                  child: Image.network(
                                    document[index]["images"][0],
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ],
                            ),
                            subtitle: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                RichText(
                                  text: TextSpan(
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          .copyWith(fontSize: 14),
                                      children: [
                                        TextSpan(
                                            text: "Price: ",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w500)),
                                        TextSpan(
                                            text:
                                                "${document[index]["price"].toString()} ",
                                            style: TextStyle(
                                                color: Colors.grey[600],
                                                fontWeight: FontWeight.w400)),
                                        TextSpan(
                                            text: "₹",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold)),
                                      ]),
                                ),

                                RichText(
                                  text: TextSpan(children: [
                                    TextSpan(
                                        text: "Category: ",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500)),
                                    TextSpan(
                                        text: document[index]["category"],
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w400))
                                  ]),
                                ),
                                RichText(
                                  text: TextSpan(children: [
                                    TextSpan(
                                        text: "Brand: ",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500)),
                                    TextSpan(
                                        text: document[index]["brand"],
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w400))
                                  ]),
                                )
                                // Text("Quntytus" +
                                //     "${document[index]["ProductName"].toString()}"),
                                // Text(document[index]["ProductName"].toString()),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                IconButton(
                                  onPressed: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              ProductDetaislEdit(
                                                documentID: documentID,
                                                productName: document[index]
                                                        ["ProductName"]
                                                    .toString(),
                                                index: index,
                                                price: document[index]["price"],
                                                quantity: document[index]
                                                    ["quantity"],
                                              ))),
                                  icon: Icon(Icons.edit),
                                ),
                                IconButton(
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
                                                      .collection(
                                                          "ProductListID")
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
                              ],
                            ),
                          ),
                        );
                        // print(i);
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
