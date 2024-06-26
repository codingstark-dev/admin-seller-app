import 'dart:async';

import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sellerapp/MainFinal.dart';


/// Run first apps open
void main() {
  runApp(MyApp());
}

/// Set orienttation
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    /// To set orientation always portrait
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    ///Set color status bar
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      statusBarColor: Colors.transparent, //or set color with: Color(0xFF0000FF)
    ));
    return  MaterialApp(
      title: "CityGrow Seller App",
      theme: ThemeData(
          brightness: Brightness.light,
          backgroundColor: Colors.white,
          primaryColorLight: Colors.white,
          primaryColorBrightness: Brightness.light,
          primaryColor: Colors.white),
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
      /// Move splash screen to ChoseLogin Layout
      /// Routes
      routes: <String, WidgetBuilder>{
        "main": (BuildContext context) => new MainFinal()               
      },
    );
  }
}

/// Component UI
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

/// Component UI
class _SplashScreenState extends State<SplashScreen> {
  /// Setting duration in splash screen
  startTime() async {
    return new Timer(Duration(milliseconds: 4500), navigatorPage);
  }
  /// To navigate layout change
  void navigatorPage() {
    Navigator.of(context).pushReplacementNamed("main");
  }
  /// Declare startTime to InitState
  @override
  void initState() {
    super.initState();
    startTime();
  }
  DateTime backbuttonpressedTime;
  /// Code Create UI Splash Screen
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: DoubleBackToCloseApp(
        snackBar: SnackBar(content: Text("Double Tap To Exit"),),
              child: Container(
          /// Set Background image in splash screen layout (Click to open code)
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/img/man.png'), fit: BoxFit.cover)),
          child: Container(
            /// Set gradient black in image splash screen (Click to open code)
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [
                      Color.fromRGBO(0, 0, 0, 0.3),
                      Color.fromRGBO(0, 0, 0, 0.4)
                    ],
                    begin: FractionalOffset.topCenter,
                    end: FractionalOffset.bottomCenter)),
            child: Center(
              child: SingleChildScrollView(
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 30.0),
                      ),
                      /// Text header "Welcome To" (Click to open code)
                      Text(
                        "Welcome to",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w200,
                          fontFamily: "Sans",
                          fontSize: 19.0,
                        ),
                      ),
                      /// Animation text CityGrow Seller App to choose Login with Hero Animation (Click to open code)
                      Hero(
                        tag: "CityGrow",
                        child: Column(
                          children: <Widget>[
                            Text(
                              "CityGrow",
                              style: TextStyle(
                                fontFamily: 'Sans',
                                fontWeight: FontWeight.w900,
                                fontSize: 35.0,
                                letterSpacing: 0.4,
                                color: Colors.white,
                              ),
                            ),
                              Text(
                              "The Seller App",
                              style: TextStyle(
                                fontFamily: 'Sans',
                                fontWeight: FontWeight.w500,
                                fontSize: 25.0,
                                letterSpacing: 0.4,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

}
