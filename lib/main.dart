import 'dart:async';

import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sellerapp/MainFinal.dart';
import 'package:sellerapp/service/notifier/service_locator.dart';
import 'package:sellerapp/theme/theme_provider.dart';

/// Run first apps open
void main() {
  serviceLocator();
  // Set `enableInDevMode` to true to see reports while in debug mode
  // This is only to be used for confirming that reports are being
  // submitted as expected. It is not intended to be used for everyday
  // development.
  // ! on it
  Crashlytics.instance.enableInDevMode = true;

  // Pass all uncaught errors to Crashlytics.

  // ! on it
  FlutterError.onError = Crashlytics.instance.recordFlutterError;
  runZoned(() {
    runApp(ChangeNotifierProvider<ThemeProvider>(
      create: (BuildContext context) => ThemeProvider(isLightTheme: true),
      child: MyApp(),
    ));
  }, onError: Crashlytics.instance.recordError);
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
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: "CityGrow Seller App",
      theme: themeProvider.getThemeData,
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),

      /// Move splash screen to ChoseLogin Layout
      /// Routes
      routes: <String, WidgetBuilder>{
        "main": (BuildContext context) => MainFinal()
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
        snackBar: SnackBar(
          content: Text("Double Tap To Exit"),
        ),
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
