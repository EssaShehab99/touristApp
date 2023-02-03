import 'package:intl/intl.dart';

class Event {
  int id;
  String name;
  String details;
  String city;
  int userID;
  DateTime from;
  DateTime to;
  List<String> images;

  Event(
      {required this.id,
      required this.name,
      required this.details,
      required this.images,
      required this.city,
      required this.userID,
      required this.from,
      required this.to});

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json["id"],
      name: json["name"],
      details: json["details"],
      userID: json["userID"],
      city: json["city"],
      from: DateFormat("yyyy-MM-dd").parse(json["from"]),
      to: DateFormat("yyyy-MM-dd").parse(json["to"]),
      images: List.from(json["images"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "details": details,
      "images": images,
      "userID": userID,
      "city": city,
      "from": DateFormat("yyyy-MM-dd").format(from),
      "to": DateFormat("yyyy-MM-dd").format(to),
    };
  }
}
