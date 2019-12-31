import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sellerapp/Screen/Admin.dart';
import 'package:sellerapp/Screen/NoInternet.dart';
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
                              return NoInternet();
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
