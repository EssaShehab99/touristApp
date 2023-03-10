class Service {
  int id;
  String name;
  String details;
  int userID;
  String city;
  List<String>? images;

  Service({required this.id, required this.name,required  this.details ,required this.city,required this.userID,  this.images});

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json["id"],
      name: json["name"],
      details: json["details"],
      images: List<String>.from(json["images"]),
      userID: json["userID"],
      city: json["city"],
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
    };
  }

}
