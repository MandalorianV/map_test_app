// To parse this JSON data, do
//
//     final markerList = markerListFromJson(jsonString);

import 'dart:convert';

List<MapMarker> markerListFromJson(String str) => List<MapMarker>.from(
      json.decode(str).map((dynamic x) => MapMarker.fromJson(x)),
    );

String markerListToJson(List<MapMarker> data) =>
    json.encode(List<dynamic>.from(data.map((MapMarker x) => x.toJson())));

class MapMarker {
  double? latitude;
  double? longitude;
  String? title;

  MapMarker({
    this.latitude,
    this.longitude,
    this.title,
  });

  factory MapMarker.fromJson(Map<String, dynamic> json) => MapMarker(
        latitude: json["latitude"]?.toDouble(),
        longitude: json["longtitude"]?.toDouble(),
        title: json["title"],
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        "latitude": latitude,
        "longtitude": longitude,
        "title": title,
      };
}
