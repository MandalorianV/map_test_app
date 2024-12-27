import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_test_app/core/cache_manager/shared_value_helper.dart';
import 'package:map_test_app/home_page/model/map_marker_mode.dart';

Future<void> mapMarkerLoader() async {
  await saved_markers.load();
}

Future<void> mapMarkerSetter(Set<Marker> markers) async {
  await saved_markers.load();
  saved_markers.$.clear();
  // if markers are ready, record will be deleted.
  if (markers.isEmpty) {
    await saved_markers.save();
    return;
  }
  for (Marker marker in markers) {
    saved_markers.$.add(
      MapMarker(
        latitude: marker.position.latitude,
        longitude: marker.position.longitude,
        title: marker.markerId.value,
      ),
    );
  }
  await saved_markers.save();
}

Future<Set<Marker>> mapMarkerGetter() async {
  Set<Marker> markers = <Marker>{};
  await saved_markers.load();

  for (dynamic marker in saved_markers.$) {
    markers.add(
      Marker(
        markerId: MarkerId(marker.title),
        position: LatLng(
          marker.latitude,
          marker.longitude,
        ),
      ),
    );
  }
  return markers;
}
