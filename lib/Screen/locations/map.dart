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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: FloatingActionButton(
                  onPressed: _originalLoc,
                  child: Icon(Icons.zoom_in),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: FloatingActionButton(
                  onPressed: _zoomOut,
                  child: Icon(Icons.zoom_out),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: FloatingActionButton(
                  onPressed: _originalLoc,
                  child: Icon(Icons.location_on),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _originalLoc() async {
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

  void _zoomOut() async {
    var pos = await location.getLocation();
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(zoom: -20, target: LatLng(pos.latitude, pos.longitude))));
  }
}
