class Area{
  int id;
  String name;
  String details;
  String city;
  int userID;
  List<String> images;

  Area({required this.id, required this.name, required this.details, required this.images, required this.city, required this.userID});


  factory Area.fromJson(Map<String, dynamic> json) {
    return Area(
      id: json["id"],
      name: json["name"],
      details: json["details"],
      userID: json["userID"],
      city: json["city"],
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
    };
  }
}