import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_test_app/home_page/view/home_view.dart';

mixin HomeViewModel on State<HomeView> {
//Variables
  final Completer<GoogleMapController> mapController =
      Completer<GoogleMapController>();
  StreamSubscription<Position>? positionStream;
  Completer<GoogleMapController> completer = Completer();
  @override
  void initState() {
    getCurrentLocation();
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    positionStream?.cancel();
    // TODO: implement dispose
    super.dispose();
  }

  Future<void> animateTo(double lat, double lng) async {
    final c = await completer.future;
    final p = CameraPosition(target: LatLng(lat, lng), zoom: 14.4746);
    c.animateCamera(CameraUpdate.newCameraPosition(p));
  }

  getCurrentLocation() {
    final LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100,
    );
    positionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((Position? position) {
      animateTo(position?.latitude ?? 0, position?.longitude ?? 0);
    });
  }
}
