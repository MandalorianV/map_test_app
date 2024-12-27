import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:map_test_app/core/helpers/global_instances.dart';
import 'package:map_test_app/core/widgets/custom_dialog.dart';

Future<void> getLocationPermissions() async {
  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    await showCustomDialog(
      context: navigatorKey.currentContext!,
      title: "Location settings disabled",
      descriptionText:
          "Please go to the location settings and enable locations.",
      buttonTextOK: "Go",
      onPressedOK: () async {
        Navigator.of(navigatorKey.currentContext!).pop();
        await Geolocator.openLocationSettings();
      },
      buttonTextCancel: "Cancel",
      onPressedCancel: () async {
        Navigator.of(navigatorKey.currentContext!).pop();
        await getLocationPermissions();
      },
    );
    return;
  }

  LocationPermission locationPermission = await Geolocator.checkPermission();

  if (isAppLocationPermissionDeniedOnce &&
      locationPermission == LocationPermission.denied) {
    await showCustomDialog(
      context: navigatorKey.currentContext!,
      title: "Location settings disabled",
      descriptionText:
          "Please go to the app settings and enable locations features.",
      buttonTextOK: "Go",
      onPressedOK: () async {
        Navigator.of(navigatorKey.currentContext!).pop();
        await Geolocator.openAppSettings();
      },
      buttonTextCancel: "Cancel",
      onPressedCancel: () async {
        Navigator.of(navigatorKey.currentContext!).pop();
        await getLocationPermissions();
      },
    );
    return;
  }

  if (locationPermission == LocationPermission.denied) {
    await Geolocator.requestPermission();
    isAppLocationPermissionDeniedOnce = true;
    await getLocationPermissions();
    return;
  }

  if (locationPermission == LocationPermission.deniedForever) {
    await showCustomDialog(
      context: navigatorKey.currentContext!,
      title: "Location settings disabled",
      descriptionText:
          "Please go to the app settings and enable locations features.",
      buttonTextOK: "Go",
      onPressedOK: () async {
        Navigator.of(navigatorKey.currentContext!).pop();
        await Geolocator.openAppSettings();
      },
      buttonTextCancel: "Cancel",
      onPressedCancel: () async {
        Navigator.of(navigatorKey.currentContext!).pop();
        await getLocationPermissions();
      },
    );

    return;
  }
}
