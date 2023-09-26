// To parse this JSON data, do
//
//     final eczane = eczaneFromJson(jsonString);

import 'dart:convert';

Eczane eczaneFromJson(String str) => Eczane.fromJson(json.decode(str));

String eczaneToJson(Eczane data) => json.encode(data.toJson());

class Eczane {
  bool success;
  List<dynamic> result;

  Eczane({
    required this.success,
    required this.result,
  });

  factory Eczane.fromJson(Map<String, dynamic> json) => Eczane(
    success: json["success"],
    result: List<dynamic>.from(json["result"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "result": List<dynamic>.from(result.map((x) => x)),
  };
}

class ResultClass {
  String name;
  String dist;
  String address;
  String phone;
  String loc;

  ResultClass({
    required this.name,
    required this.dist,
    required this.address,
    required this.phone,
    required this.loc,
  });

  factory ResultClass.fromJson(Map<String, dynamic> json) => ResultClass(
    name: json["name"],
    dist: json["dist"],
    address: json["address"],
    phone: json["phone"],
    loc: json["loc"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "dist": dist,
    "address": address,
    "phone": phone,
    "loc": loc,
  };
}
