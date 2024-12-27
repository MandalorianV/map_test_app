import 'dart:convert';

String listToJson(List<MapMarker> markers) {
  return jsonEncode(markers.map((marker) => marker.toJson()).toList());
}

List<MapMarker> listFromJson(String jsonString) {
  final List<dynamic> jsonList = jsonDecode(jsonString);
  return jsonList
      .map((item) => MapMarker.fromJson(item as Map<String, dynamic>))
      .toList();
}

class MapMarker {
  final double latitude;
  final double longitude;
  final String title;

  MapMarker({
    required this.latitude,
    required this.longitude,
    required this.title,
  });

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'title': title,
    };
  }

  factory MapMarker.fromJson(Map<String, dynamic> json) {
    return MapMarker(
      latitude: json['latitude'],
      longitude: json['longitude'],
      title: json['title'],
    );
  }
}
