class Helper {
  int id;
  String name;
  String email;
  String phone;
  int age;
  String gender;
  String nationality;
  int userID;
  int serviceID;
  List<String> images;

  Helper(
      {required this.id,
      required this.name,
      required this.email,
      required this.phone,
      required this.age,
      required this.gender,
      required this.nationality,
      required this.images,
      required this.userID,
      required this.serviceID});

  factory Helper.fromJson(Map<String, dynamic> json) {
    return Helper(
      id: json["id"],
      name: json["name"],
      email: json["email"],
      phone: json["phone"],
      age: json["age"],
      gender: json["gender"],
      nationality: json["nationality"],
      images: List<String>.from(json["images"]),
      userID: json["userID"],
      serviceID: json["serviceID"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "email": email,
      "phone": phone,
      "age": age,
      "gender": gender,
      "nationality": nationality,
      "images": images,
      "userID": userID,
      "serviceID": serviceID,
    };
  }
//
}
