import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';

class VerificationDb extends StatefulWidget {
  @override
  _VerificationDbState createState() => _VerificationDbState();
}

class _VerificationDbState extends State<VerificationDb> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Verfication Pending"),
        centerTitle: true,
      ),
      body: DoubleBackToCloseApp(
        snackBar: SnackBar(content: Text("Double Tap To Exit")),
        child: Container(
            child: Stack(
          children: <Widget>[
            FlareActor(
              "assets/flare/verify.flr",
              // alignment: Alignment.topCenter,
              fit: BoxFit.contain,
              animation: "otp",
            ),
          ],
        )),
      ),
    );
  }
}
