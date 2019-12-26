import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sellerapp/model/user.dart';
import 'package:sellerapp/service/auth.dart';
import 'Screen/Wrapper.dart';

final MaterialColor active = Colors.purple;
void main() =>
    runApp(MaterialApp(theme: ThemeData(hintColor: active,primaryColor: active), home: MainFinal()));

class MainFinal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return MultiProvider(
      providers: [
        StreamProvider<User>.value(
          value: AuthService().user,
        ),
        Provider<AuthService>(
          create: (BuildContext context) => AuthService(),
        ),
        
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Wrapper(),
      ),
    );
  }
}
