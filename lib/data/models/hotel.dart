class Hotel {
  int id;
  String name;
  String details;
  String city;
  int userID;
  List<String> images;

  Hotel(
      {required this.id,
      required this.name,
        required this.images,
        required this.details,
      required this.city,
      required this.userID});

  factory Hotel.fromJson(Map<String, dynamic> json) {
    return Hotel(
      id: json["id"],
      name: json["name"],
      details: json["details"],
      city: json["city"],
      userID: json["userID"],
        images: List.from(json["images"]));
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "details": details,
      "city": city,
      "images": images,
      "userID": userID,
    };
  }
//
}
