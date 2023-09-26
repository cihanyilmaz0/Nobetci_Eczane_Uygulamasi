// To parse this JSON data, do
//
//     final district = districtFromJson(jsonString);

import 'dart:convert';

List<District> districtFromJson(String str) => List<District>.from(json.decode(str).map((x) => District.fromJson(x)));

String districtToJson(List<District> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class District {
  String city;
  String district;

  District({
    required this.city,
    required this.district,
  });

  factory District.fromJson(Map<String, dynamic> json) => District(
    city: json["CITY"],
    district: json["DISTRICT"],
  );

  Map<String, dynamic> toJson() => {
    "CITY": city,
    "DISTRICT": district,
  };
}


class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
