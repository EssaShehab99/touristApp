class Hotel {
  int id;
  String name;
  String details;
  String city;
  int userID;

  Hotel(
      {required this.id,
      required this.name,
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
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "details": details,
      "city": city,
      "userID": userID,
    };
  }
//
}
