import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';
import 'package:sellerapp/Screen/Admin.dart';
import 'package:sellerapp/Screen/formDetails.dart';
import 'package:sellerapp/Screen/verification.dart';
import 'package:sellerapp/model/user.dart';
import 'package:sellerapp/service/dbapi.dart';
import 'package:sellerapp/service/streamfiles.dart';
import 'LoginOrSignUp/Signup.dart';
import 'package:url_launcher/url_launcher.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  void initState() {
    try {
      versionCheck(context);
    } catch (e) {
      print(e);
    }
    super.initState();
  }

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

//Prompt users to update app if there is a new version available
//Uses url_launcher package

  final playStoreLink =
      'https://play.google.com/store/apps/details?id=in.citygrow.seller';

  versionCheck(context) async {
    //Get Current installed version of app
    final PackageInfo info = await PackageInfo.fromPlatform();
    double currentVersion =
        double.parse(info.version.trim().replaceAll(".", ""));

    //Get Latest version info from firebase config
    final RemoteConfig remoteConfig = await RemoteConfig.instance;

    try {
      // Using default duration to force fetching from remote server.
      await remoteConfig.fetch(expiration: const Duration(seconds: 0));
      await remoteConfig.activateFetched();
      remoteConfig.getString('force_update_current_version');
      double newVersion = double.parse(remoteConfig
          .getString('force_update_current_version')
          .trim()
          .replaceAll(".", ""));
      if (newVersion > currentVersion) {
        _showVersionDialog(context);
      }
    } on FetchThrottledException catch (exception) {
      // Fetch throttled.
      print(exception);
    } catch (exception) {
      print('Unable to fetch remote config. Cached or default values will be '
          'used');
    }
  }

//Show Dialog to force user to update
  _showVersionDialog(context) async {
    await showDialog<String>(
      useRootNavigator: false,
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        String title = "New Update Available!!";
        String message =
            "There is a newer version of app available please update it now. If your not going to update your app will not work!!";
        String btnLabel = "Update Now!";
        // String btnLabelCancel = "Later";

        return WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15.0))),
            elevation: 0.5,
            title: Text(title),
            content: Text(message),
            scrollable: true,
            actions: <Widget>[
              RaisedButton(
                color: Colors.deepPurple[400],
                onPressed: () => _launchURL(playStoreLink),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4.0))),
                child: Text(btnLabel),
              ),
              // FlatButton(
              //   color: Colors.deepPurple[400],
              //   child: Text(btnLabel),
              //   onPressed: () => _launchURL(playStoreLink),
              // ),
              // FlatButton(
              //   child: Text(btnLabelCancel),
              //   onPressed: () => Navigator.pop(context),
              // ),
            ],
          ),
        );
      },
    );
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
