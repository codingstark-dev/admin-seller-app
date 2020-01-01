import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:sellerapp/Screen/Admin.dart';
import 'package:sellerapp/Screen/formDetails.dart';
import 'package:sellerapp/Screen/verification.dart';
import 'package:sellerapp/model/user.dart';
import 'package:sellerapp/service/dbapi.dart';
import 'package:sellerapp/service/streamfiles.dart';
import 'LoginOrSignUp/Signup.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    final db = DatabaseService(uid: user?.uid, name: user?.name);
    // .forEach((doc) => doc.verificationDone);
    bool condition = true;
    //  ! return ethier Home or auth widget
    if (user == null) {
      return Signup();
    } else {
      return MultiProvider(
        providers: [
          StreamProvider<UserDetails>.value(
            catchError: (_, __) => null,
            value: DatabaseService(uid: user?.uid).documentSnapshot,
          ),
        ],
        child: StreamBuilder<UserDetails>(
            stream: db?.documentSnapshot,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data.formDetaiVerify == true) {
                  if (snapshot.data.verificationWaiting == true) {
                    return StreamBuilder<ConnectivityResult>(
                        stream: Connectivity().onConnectivityChanged,
                        builder: (context, snapshot) {
                          if (!snapshot.hasData)
                            return CircularProgressIndicator();
                          var result = snapshot.data;
                          switch (result) {
                            case ConnectivityResult.none:
                              print("no net");
                              if (ConnectivityResult.none ==
                                  ConnectivityResult.none) {
                                Future.delayed(const Duration(seconds: 25),
                                    () => condition = false);

                                Stream.periodic(const Duration(seconds: 5))
                                    .takeWhile((_) => condition)
                                    .forEach((e) {
                                  print('event: $e');

                                  return Fluttertoast.showToast(
                                      toastLength: Toast.LENGTH_LONG,
                                      msg:
                                          "No Internet Connection Check Your Internet Connection",
                                      gravity: ToastGravity.BOTTOM);
                                });
                              }
                              // Timer.periodic(Duration(seconds: 5), (timer) {
                              //   if (ConnectivityResult.none ==
                              //   ConnectivityResult.none) {
                              //      Fluttertoast.showToast(
                              //       msg: "No Internet",
                              //       gravity: ToastGravity.CENTER);
                              //   }else{
                              //      timer.cancel();
                              //   }

                              // });

                              // Future.delayed(const Duration(seconds: 1), () {
                              //   return Fluttertoast.showToast(
                              //       msg: "No Internet",
                              //       gravity: ToastGravity.CENTER);
                              // });
                              // Future.delayed(const Duration(seconds: 5), () {
                              //   return Fluttertoast.showToast(
                              //       msg: "No Internet",
                              //       gravity: ToastGravity.CENTER);
                              // });  Future.delayed(const Duration(seconds: 10), () {
                              //   return Fluttertoast.showToast(
                              //       msg: "No Internet",
                              //       gravity: ToastGravity.CENTER);
                              // });  Future.delayed(const Duration(seconds: 20), () {
                              //   return Fluttertoast.showToast(
                              //       msg: "No Internet",
                              //       gravity: ToastGravity.CENTER);
                              // });  Future.delayed(const Duration(seconds: 30), () {
                              //   return Fluttertoast.showToast(
                              //       msg: "No Internet",
                              //       gravity: ToastGravity.CENTER);
                              // });
                              return Scaffold(
                                body: Center(
                                  child: Column(
                                    children: <Widget>[
                                      Expanded(
                                          flex: 3,
                                          child: Center(
                                              child: CircularProgressIndicator(
                                            backgroundColor: Colors.red,
                                          ))),
                                      Expanded(
                                          flex: 1,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              "Check Internet Connection Or You Are Using Poor Connection",
                                              style: TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ))
                                    ],
                                  ),
                                ),
                              );
                            case ConnectivityResult.mobile:
                            case ConnectivityResult.wifi:
                              print("yes net");

                              return Admin();
                            default:
                              return Center(
                                  child: Text("No Internet Connection!"));
                          }
                        });
                  }
                  return VerificationDb();
                } else {
                  return FormDetails();
                }
              } else if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return Container();
              }
            }),
      );
    }
  }
}
