import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_test_app/core/cache_manager/shared_value_function_helper.dart';

final SharedValue<Set<Marker>> saved_markers = SharedValue<Set<Marker>>(
  value: <Marker>{}, // initial value
  key: "saved_markers", // disk storage key for shared_preferences
);
