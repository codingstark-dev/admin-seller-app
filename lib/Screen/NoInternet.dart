import 'package:flutter/material.dart';

class NoInternet extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    Color active = Colors.deepPurple[400];
    return Scaffold(
      appBar: AppBar(
        title: Text("No Internet Connection"),
        centerTitle: true,
        automaticallyImplyLeading: true,
        backgroundColor: active,
      ),
      body: Container(
        child: Icon(Icons.signal_cellular_connected_no_internet_4_bar)
      ),
    );
  }
}