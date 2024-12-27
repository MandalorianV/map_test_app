import 'package:flutter/material.dart';
import 'package:map_test_app/core/helpers/location_permission_handler.dart';

Future<void> appInitializer() async {
  WidgetsFlutterBinding.ensureInitialized();
  await getLocationPermissions();
}
