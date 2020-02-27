// import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sellerapp/model/user.dart';
import 'package:sellerapp/service/dbapi.dart';
import 'package:sellerapp/service/streamfiles.dart';

class FormDetailNotifications extends StatefulWidget {
  FormDetailNotifications(
      {Key key, this.title, this.message, this.buttonTile, this.buttonFuc})
      : super(key: key);

  final String title;
  final String message;
  final String buttonTile;
  final Function buttonFuc;

  @override
  _FormDetailNotificationsState createState() =>
      _FormDetailNotificationsState();
}

class _FormDetailNotificationsState extends State<FormDetailNotifications> {
  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<User>(context);
    final db = DatabaseService(uid: user.uid);
    return StreamBuilder<UserDetails>(
        stream: db?.documentSnapshot,
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(
              child: CircularProgressIndicator(),
            );
          final data = snapshot.data.bankDetailBool;
          switch (data) {
            case true:
              return Container();
              break;
            case false:
              return Card(
                elevation: 1.0,
                color: Colors.red,
                child: ListTile(
                  leading: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.warning,
                      color: Colors.white,
                    ),
                  ),
                  title: Container(
                    color: Colors.white10,
                    // clipBehavior: Clip.hardEdge,
                    child: Text(
                      widget.title,
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w600),
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 5, 0, 2),
                    child: Text(widget.message,
                        style: TextStyle(color: Colors.white)),
                  ),
                  contentPadding: EdgeInsets.all(5),
                  trailing: FlatButton(
                    highlightColor: Colors.white10,
                    color: Colors.white10,
                    onPressed: widget.buttonFuc,
                    child: Text(
                      widget.buttonTile,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              );
              // return Flushbar(
              //   title: widget.title,
              //   message: widget.message,
              //   flushbarPosition: FlushbarPosition.TOP,
              //   flushbarStyle: FlushbarStyle.FLOATING,
              //   reverseAnimationCurve: Curves.decelerate,
              //   forwardAnimationCurve: Curves.elasticOut,
              //   backgroundColor: Colors.red,
              //   // boxShadows: [BoxShadow(color: Colors.blue[800], offset: Offset(0.0, 2.0), blurRadius: 3.0)],
              //   // backgroundGradient: LinearGradient(colors: [Colors.blueGrey, Colors.black]),
              //   isDismissible: false,
              //   duration: Duration(seconds: 4),
              //   icon: Icon(
              //     Icons.error_outline,
              //     color: Colors.white,
              //   ),
              //   mainButton: FlatButton(
              //     onPressed: widget.buttonFuc,
              //     child: Text(
              //       widget.buttonTile,
              //       style: TextStyle(color: Colors.white),
              //     ),
              //   ),
              //   // showProgressIndicator: true,
              //   // progressIndicatorBackgroundColor: Colors.blueGrey,
              //   // titleText: Text(
              //   //   "Hello Hero",
              //   //   style: TextStyle(
              //   //       fontWeight: FontWeight.bold, fontSize: 20.0, color: Colors.white, fontFamily: "ShadowsIntoLightTwo"),
              //   // ),
              //   // messageText: Text(
              //   //   "You killed that giant monster in the city. Congratulations!",
              //   //   style: TextStyle(fontSize: 18.0, color: Colors.green, fontFamily: "ShadowsIntoLightTwo"),
              //   // ),
              // );
              break;
            default:
              return Container();
          }
        });
  }
}
