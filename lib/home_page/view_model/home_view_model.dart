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
  Completer<GoogleMapController> completer = Completer<GoogleMapController>();
  Set<Marker> markers = <Marker>{};
  Position? currentPosition;
  ValueNotifier<dynamic> updateMarkers = ValueNotifier<dynamic>("");
  bool isPathRecording = false;

  @override
  void initState() {
    unawaited(getCachedMarkers());
    getCurrentLocation();

    super.initState();
  }

  @override
  void dispose() {
    unawaited(positionStream?.cancel());

    super.dispose();
  }

  Future<void> getCachedMarkers() async {
    markers = await getMarkerList();
    updateMarkers.value = markers;
  }

  Future<void> animateTo(double lat, double lng) async {
    final GoogleMapController c = await completer.future;
    final CameraPosition p =
        CameraPosition(target: LatLng(lat, lng), zoom: 14.4746);
    await c.animateCamera(CameraUpdate.newCameraPosition(p));
  }

  void getCurrentLocation() {
    final LocationSettings locationSettings = const LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 20,
    );
    positionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((Position? position) async {
      currentPosition = position;
      if (isPathRecording) {
        putMarkerByDistance(100.0);
      }
      await animateTo(position?.latitude ?? 0, position?.longitude ?? 0);
    });
  }

  void addMarker(Position? position) {
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

  void putMarkerByDistance(double meter) {
    if (markers.isEmpty) {
      addMarker(currentPosition);
      return;
    }
    double calculatedDistance = calculateDistance(
      currentPosition?.latitude ?? 0,
      currentPosition?.longitude ?? 0,
      markers.last.position.latitude,
      markers.last.position.longitude,
    );
    calculatedDistance *= 1000;
    if (calculatedDistance > meter) {
      addMarker(currentPosition);
    }
  }

  void onMapCreated(GoogleMapController controller) {
    completer.complete(controller);
  }

  Future<void> save() async {
    if (markers.isEmpty) {
      customSnackBar(text: "There is no marker to save.", color: Colors.red);
      return;
    }
    await saveMarkerList(markers);
    customSnackBar(text: "Markers saved.", color: Colors.green);
  }

  void playRecording() {
    context.read<HomeBloc>().add(PathRecorderEvent(activate: isPathRecording));
    addMarker(currentPosition);
  }

  Future<void> deleteRecording() async {
    Set<Marker> savedMarkers = await getMarkerList();
    if (savedMarkers.isEmpty) {
      context
          .read<HomeBloc>()
          .add(PathRecorderEvent(activate: isPathRecording));
      customSnackBar(
        text: "There is no recorded marker.",
        color: Colors.orange,
      );
      return;
    }
    markers.clear();
    await saveMarkerList(markers);
    updateMarkers.value = markers;
    context.read<HomeBloc>().add(PathRecorderEvent(activate: isPathRecording));
    customSnackBar(text: "Map records deleted.", color: Colors.green);
  }

  void clearMap() {
    markers.clear();
    updateMarkers.value = markers;
    customSnackBar(text: "Map cleared.", color: Colors.green);
    //put clear message here
  }

  Future<void> centerMap() async {
    await animateTo(
      currentPosition?.latitude ?? 0,
      currentPosition?.longitude ?? 0,
    );
  }
}
