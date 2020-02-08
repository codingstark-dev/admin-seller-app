import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  Completer<GoogleMapController> _controller = Completer();
  MapType type;
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );
  Location location = new Location();

  Set<Marker> markers;
  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    markers = Set.from([]);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Stack(
        children: <Widget>[
          GoogleMap(
            compassEnabled: true,
            buildingsEnabled: true,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            tiltGesturesEnabled: false,
            markers: markers,
            mapType: MapType.normal,
            initialCameraPosition: _kGooglePlex,
            onTap: (argument) {
              Marker mk1 = Marker(
                  markerId: MarkerId("value"),
                  position: argument,
                  draggable: true);
              setState(() {
                markers.add(mk1);
              });
              print(argument);
            },
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: FloatingActionButton.extended(
              onPressed: _goToTheLake,
              label: Text('To the lake!'),
              icon: Icon(Icons.directions_boat),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _goToTheLake() async {
    var pos = await location.getLocation();
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(pos.latitude, pos.longitude), zoom: 20)));
    final mk2 = Marker(
        markerId: MarkerId("value"),
        position: LatLng(pos.latitude, pos.longitude));
    setState(() {
      markers.remove(mk2);
      markers.add(mk2);
    });
  }
}
