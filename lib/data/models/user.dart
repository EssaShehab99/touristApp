import '/data/utils/enum.dart';

class User {
  int id;
  String name;
  String email;
  String phone;
  int? age;
  String password;

  User(
      {required this.id,
      required this.name,
      required this.email,
      required this.phone,
      required this.age,
      required this.password});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json["id"],
      name: json["name"],
      email: json["email"],
      phone: json["phone"],
      age: json["age"],
      password: json["password"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "email": email,
      "phone": phone,
      "age": age,
      "password": password,
    };
  }
//

}
