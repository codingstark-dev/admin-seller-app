import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';

class VerificationDb extends StatefulWidget {
  @override
  _VerificationDbState createState() => _VerificationDbState();
}

Color active = Colors.deepPurple[400];

class _VerificationDbState extends State<VerificationDb> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Verfication Pending"),
        centerTitle: true,
        backgroundColor: active,
      ),
      body: DoubleBackToCloseApp(
        snackBar: SnackBar(content: Text("Double Tap To Exit")),
        child: SafeArea(
                  child: Container(
              child: Stack(
            children: <Widget>[
              FlareActor(
                "assets/flare/otp.flr",
                // alignment: Alignment.topCenter,
                fit: BoxFit.contain,
                animation: "otp",
                alignment: Alignment.topCenter,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 240, 0, 0),
                child: SafeArea(
                                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Center(
                          child: Text(
                        "Your Detail Verification Pending!",
                        style: TextStyle(
                            color: active,
                            fontSize: 16,
                            fontWeight: FontWeight.w700),
                      )),
                      SizedBox(height: 5,),
                      Center(
                          child: Text(
                        "Our Team Verifying Your Given Details",
                        style: TextStyle(
                            color: active,
                            fontSize: 16,
                            fontWeight: FontWeight.w700),
                      )),
                         SizedBox(height: 5,),
                       Center(
                          child: Text(
                        "If You Given Wrong Details In form Contact Us",
                        style: TextStyle(
                            color: active,
                            fontSize: 16,
                            fontWeight: FontWeight.w700),
                      )),
                         SizedBox(height: 5,),
                         Center(
                          child: Text(
                        "- +918999996369 \n- geteasytodaygroup@gmail.com",textAlign: TextAlign.center,
                        style: TextStyle(
                            color: active,
                            fontSize: 16,
                            fontWeight: FontWeight.w700),
                      )),
                    ],
                  ),
                ),
              )
            ],
          )),
        ),
      ),
    );
  }
}
