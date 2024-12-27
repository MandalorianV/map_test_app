import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_test_app/core/helpers/calculate_distance_helper.dart';
import 'package:map_test_app/core/helpers/map_marker_save_helper.dart';
import 'package:map_test_app/core/widgets/custom_snackbar.dart';
import 'package:map_test_app/home_page/bloc/home_bloc.dart';
import 'package:map_test_app/home_page/view/home_view.dart';

mixin HomeViewModel on State<HomeView> {
//Variables
  final Completer<GoogleMapController> mapController =
      Completer<GoogleMapController>();
  StreamSubscription<Position>? positionStream;
  Completer<GoogleMapController> completer = Completer();
  Set<Marker> markers = <Marker>{};
  Position? currentPosition;
  ValueNotifier updateMarkers = ValueNotifier<dynamic>("");
  bool isPathRecording = false;

  @override
  void initState() {
    getCachedMarkers();
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

  getCachedMarkers() async {
    markers = await mapMarkerGetter();
  }

  Future<void> animateTo(double lat, double lng) async {
    final c = await completer.future;
    final p = CameraPosition(target: LatLng(lat, lng), zoom: 14.4746);
    c.animateCamera(CameraUpdate.newCameraPosition(p));
  }

  getCurrentLocation() {
    final LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 20,
    );
    positionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((Position? position) async {
      currentPosition = position;
      putMarkerByDistance(100.0);
      await animateTo(position?.latitude ?? 0, position?.longitude ?? 0);
    });
  }

  addMarker(Position? position) {
    if (position is! Position) {
      // position could not be taken.
      return;
    }
    markers.add(
      Marker(
        markerId: MarkerId(
          position.timestamp.millisecondsSinceEpoch.toString(),
        ),
        position: LatLng(
          position.latitude,
          position.longitude,
        ),
        icon: BitmapDescriptor.defaultMarker,
      ),
    );
    updateMarkers.value = position.timestamp.millisecondsSinceEpoch.toString();
  }

  putMarkerByDistance(double meter) {
    if (markers.isEmpty) {
      return;
    }
    double calculatedDistance = calculateDistance(
      currentPosition?.latitude,
      currentPosition?.longitude,
      markers.last.position.latitude,
      markers.last.position.longitude,
    );
    calculatedDistance *= 1000;
    if (calculatedDistance > meter) {
      addMarker(currentPosition);
    }
  }

  onMapCreated(GoogleMapController controller) {
    completer.complete(controller);
  }

  Future<void> save() async {
    if (markers.isEmpty) {
      customSnackBar(text: "There is no marker to save.", color: Colors.red);
      return;
    }
    await mapMarkerSetter(markers);
    customSnackBar(text: "Markers saved.", color: Colors.green);
  }

  playRecording() {
    context.read<HomeBloc>().add(PathRecorderEvent(activate: isPathRecording));
    addMarker(currentPosition);
  }

  deleteRecording() async {
    markers.clear();
    await mapMarkerSetter(markers);
    updateMarkers.value = markers;
    context.read<HomeBloc>().add(PathRecorderEvent(activate: isPathRecording));
    customSnackBar(text: "Map records deleted.", color: Colors.green);
  }

  clearMap() {
    markers.clear();
    updateMarkers.value = markers;
    customSnackBar(text: "Map cleared.", color: Colors.green);
    //put clear message here
  }

  centerMap() async {
    await animateTo(
        currentPosition?.latitude ?? 0, currentPosition?.longitude ?? 0);
  }
}
