import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_test_app/home_page/model/map_marker_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveMarkerList(Set<Marker> markers) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<MapMarker> mapMarkers = [];
  for (Marker marker in markers) {
    mapMarkers.add(MapMarker(
        latitude: marker.position.latitude,
        longitude: marker.position.longitude,
        title: marker.markerId.value));
  }
  String jsonMarkerList = markerListToJson(mapMarkers);
  await prefs.setString('marker_list', jsonMarkerList);
}

Future<Set<Marker>> getMarkerList() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String markerListString = prefs.getString('marker_list') ?? "";
  if (markerListString.isEmpty) {
    return <Marker>{};
  }
  List<MapMarker> mapMarkers = markerListFromJson(markerListString);
  Set<Marker> markers = <Marker>{};
  for (MapMarker marker in mapMarkers) {
    markers.add(
      Marker(
        markerId: MarkerId(marker.title ?? ""),
        position: LatLng(
          marker.latitude ?? 0,
          marker.longitude ?? 0,
        ),
      ),
    );
  }
  return markers;
}
