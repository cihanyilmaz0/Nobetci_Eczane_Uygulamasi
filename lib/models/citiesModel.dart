// To parse this JSON data, do
//
//     final cities = citiesFromJson(jsonString);

import 'dart:convert';

List<Cities> citiesFromJson(String str) => List<Cities>.from(json.decode(str).map((x) => Cities.fromJson(x)));

String citiesToJson(List<Cities> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Cities {
  int id;
  String text;

  Cities({
    required this.id,
    required this.text,
  });

  factory Cities.fromJson(Map<String, dynamic> json) => Cities(
    id: json["ID"],
    text: json["TEXT"],
  );

  Map<String, dynamic> toJson() => {
    "ID": id,
    "TEXT": text,
  };
}
