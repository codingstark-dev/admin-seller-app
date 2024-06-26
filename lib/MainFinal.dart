import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sellerapp/model/user.dart';
import 'package:sellerapp/service/auth.dart';
import 'package:sellerapp/service/dbapi.dart';
import 'Screen/Wrapper.dart';

Color active = Colors.deepPurple[400];
void main() => runApp(MainFinal());

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
        Provider<UserDetails>(
          create: (BuildContext context) => UserDetails(),
        ),
      ],
      child: Consumer<User>(
        builder: (BuildContext context, value, Widget child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Wrapper(),
          );
        },
      ),
    );
  }
}
