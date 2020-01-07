import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sellerapp/model/user.dart';
import 'package:sellerapp/service/dbapi.dart';
import 'package:sellerapp/service/streamfiles.dart';

class Rewards extends StatefulWidget {
  Rewards({Key key}) : super(key: key);

  @override
  _RewardsState createState() => _RewardsState();
}

Color active = Colors.deepPurple[400];

class _RewardsState extends State<Rewards> {
  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<User>(context);
    final db = DatabaseService(uid: user.uid);
    return Scaffold(
      appBar: AppBar(
        title: Text("Reward"),
        backgroundColor: active,
        centerTitle: true,
      ),
      body: StreamBuilder<UserDetails>(
          stream: db?.documentSnapshot,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final data = snapshot.data;
              return Column(
                children: <Widget>[
                  Card(
                    color: active,
                    child: Container(
                      height: 100,
                      width: MediaQuery.of(context).size.height,
                      child: Center(
                          child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                            child: Text(
                              "Your Points: ${data.rewards}",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                            child: Text(
                              "Your Refer ID: ${data.referalId}",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15),
                            ),
                          ),
                        ],
                      )),
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.all(4),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Joined User -",
                      )),
                  StreamBuilder(
                      stream: Firestore.instance
                          .collection("Sellers")
                          .document(user.uid)
                          .collection("joined User")
                          .where("RefferalId", isEqualTo: data.referalId)
                          .snapshots(),
                      builder: (context, userjoined) {
                        if (userjoined.hasData) {
                          if (userjoined.data.documents.length == 0) {
                            return Padding(
                              padding: const EdgeInsets.fromLTRB(0, 120, 0, 0),
                              child: Center(
                                  child: Text(
                                "There Are No User Joined Form Your ReferCode!!",
                                style: TextStyle(
                                    color: Colors.grey[350],
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500),
                              )),
                            );
                          } else {
                            final List<DocumentSnapshot> document =
                                userjoined?.data?.documents;
                            return Container(
                                height:
                                    MediaQuery.of(context).size.height / 1.6,
                                child: ListView.builder(
                                    itemCount: document?.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Card(
                                        elevation: 0.5,
                                        child: ListTile(
                                          leading: Text("${index + 1}"),
                                          title: Text(document[index]["Name"]),
                                        ),
                                      );
                                    }));
                          }
                        } else {
                          return Center(
                              child: CircularProgressIndicator(
                            backgroundColor: active,
                          ));
                        }
                      })
                ],
              );
            } else {
              return Center(
                  child: CircularProgressIndicator(
                backgroundColor: active,
              ));
            }
          }),
    );
  }
}
