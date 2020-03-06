import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sellerapp/Screen/locations/location_service.dart';
import 'package:sellerapp/model/user.dart';
import 'package:sellerapp/service/auth.dart';
import 'package:sellerapp/service/dbapi.dart';
import 'package:sellerapp/service/notifier/promocode.dart';
import 'package:sellerapp/theme/theme_provider.dart';
import 'Screen//wrapper/Wrapper.dart';

Color active = Colors.deepPurple[400];
void main() => runApp(MainFinal());

class MainFinal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MultiProvider(
        providers: [
          StreamProvider<User>.value(
            value: AuthService().user,
          ),
          StreamProvider(
            create: (BuildContext context) => LocationService().locationStream,
          ),
          Provider<AuthService>(
            create: (BuildContext context) => AuthService(),
          ),
          Provider<UserDetails>(
            create: (BuildContext context) => UserDetails(),
          ),
          Provider<PromoBase>(
            create: (BuildContext context) => PromoBase(),
          ),
        ],
        child: MaterialApp(
          theme: themeProvider.getThemeData,
          debugShowCheckedModeBanner: false,
          home: Wrapper(),
        ));
  }
}
